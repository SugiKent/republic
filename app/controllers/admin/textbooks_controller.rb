class Admin::TextbooksController < AdminController
  def index
    @textbooks = TextBook.includes(:lessons).where(lessons: { year: 2018 }).page(params[:page]).per(21)
  end

  def search
    @textbooks = TextBook.includes(:lessons).where(lessons: { year: 2018 }).order(:title).all

    # 動的にget_by系のメソッドを呼び出している
    %w[title author publisher published_year].each do |column|
      next unless params[column].present?
      # 1文字以上の空白文字で区切る
      params[column].split(/[[:blank:]]+/).each do |_column_val|
        eval "@textbooks = @textbooks.get_by_#{column}(column_val)"
      end
    end

    flash.now[:searched] = "検索の結果#{@textbooks.count}件見つかりました！"
    @textbooks = @textbooks.page(params[:page]).per(21)
    respond_to do |format|
      format.html
    end
  end

  def show
    @textbook = TextBook.find(params[:id])
    @stores = BookStore.where(text_book_id: params[:id])
  end
end
