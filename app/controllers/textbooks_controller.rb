class TextbooksController < SessionsController
  before_action :basic_auth, except: %i[search show purchase ship]

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
  end

  def ship
    if current_user.blank?
      # ユーザーがログインしていない場合
      redirect_to request.referrer, alert: '登録にはログインが必要です。'
      return false
    elsif current_user.id != params[:having_user].to_i && current_user.id != params[:request_user].to_i
      # ログインユーザーとparamsのユーザーが異なる場合
      redirect_to request.referrer, alert: '不正な操作です。'
      return false
    end

    @ship = BookRequest.new(text_book_id: params[:id], having_user_id: params[:having_user], request_user_id: params[:request_user])

    message = if params[:having_user]
                '持っている'
              else
                '欲しい'
    end

    if @ship.save
      unless Rails.env.development?
        SlackNotifier.notify_to_slack("教科書がリクエストされたよー\n\n---\n\nhttps://www.rep-rikkyo.com/admin/textbooks/#{@ship.text_book_id}\n\n----\n\n#{@ship.request_user_id}\n\n----\n\n#{@ship.created_at}", Settings.slack_webhook.book_request)
      end

      flash[:info] = "#{message}本をレクエストしました！\r\n登録済みのメールに連絡が来るまで今しばらくお待ちください。"
      redirect_to request.referrer
    else
      redirect_to request.referrer, alert: '登録に失敗しました。'
    end
  end

  def purchase
    # code
  end

  private

  def check_matching
    if params[:having_user].present?
      # 「持っている」場合
      # 「欲しい」ユーザーを探す
      BookRequest.where(text_book_id: params[:id]).where.not(request_user_id: nil)
    else
      # 「欲しい」場合
      # 「持っている」ユーザーを探す
      BookRequest.where(text_book_id: params[:id]).where.not(having_user_id: nil)
    end
  end
end
