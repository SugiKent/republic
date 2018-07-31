class Admin::BookstoresController < AdminController
  def create
    @textbook = TextBook.find(params[:text_book_id])

    if @textbook.book_stores.create
      flash[:success] = '1つ在庫を登録しました。'
      redirect_to admin_textbook_path(@textbook)
    else
      flash[:danger] = '失敗しました。'
      redirect_to admin_textbook_path(@textbook)
    end
  end

  def destroy
    @store = BookStore.find(params[:id])
    @textbook = TextBook.find(@store.text_book_id)

    @store.toggle(:is_sold)

    if @store.save
      flash[:success] = if @store.is_sold
                          '1つ在庫を販売完了にしました。'
                        else
                          '1つ在庫を販売中にしました。'
                        end
      redirect_to admin_textbook_path(@textbook)
    else
      flash[:success] = '失敗しました。'
      redirect_to admin_textbook_path(@textbook)
    end
  end
end
