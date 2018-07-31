class PdfsController < SessionsController
  def index
    @faculties = Faculty.includes(:departments).joins(:departments).published_departments.all
  end

  def result
    term = params[:term]
    department_ids = params[:department_ids].split(/\W/) # splitで、配列っぽい文字列を配列にしています。
    @departments = Department.where(id: department_ids)

    pdf_name = ''

    # お気に入り授業を含める場合
    if params[:favorites]
      if current_user.blank?
        flash[:alert] = 'お気に入り授業を含めるにはログインが必要です。'
        redirect_to pdfs_path
        return false
      end
      lessons = Lesson.includes(:department).joins(:department).get_by_term(term).get_by_department(department_ids)

      favorite_lessons = current_user.lessons.includes(:department).joins(:department).get_by_term(term)
      @lessons = Lesson.where(id: (lessons + favorite_lessons).map(&:id))
      pdf_name += '【お気に入り授業】'
    else
      @lessons = Lesson.includes(:department).joins(:department).get_by_term(term).get_by_department(department_ids)
    end

    @departments.each do |d|
      pdf_name += '【' + d.department_name + '】'
    end
    @term_name = Lesson::TERMS[term]
    respond_to do |format|
      # 次の一文「format.html」は必須。
      format.html
      format.pdf do
        render pdf: "Rep_#{@term_name}_#{pdf_name} の時間割", # pdf ファイル名
               encording: 'UTF-8',                   # 日本語を使う場合には指定する
               layout: 'pdf.html',                   # レイアウトファイルの指定
               show_as_html: params[:debug].present?, # debug するか？
               orientation: 'Landscape', # 向きを変更
               margin: {
                 top: 5, # 単位はmm
                 bottom: 5,
                 left: 5,
                 right: 5
               }
      end
    end
  end
end
