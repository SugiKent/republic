require 'pry'
require 'rails_helper'

RSpec.describe Classes::ResultController, type: :controller do

  describe 'GET #index' do

    context 'ユーザーがログインしていない時、' do
      it '302がresponseされる' do
        get :index
        expect(response.code).to eq '302'
      end
    end

    context 'ユーザーがログインしている時、' do

      before do
        @user = create(:user)
        login_user(@user)
      end

      it '200がresponseされる' do
        get :index
        expect(response.code).to eq '200'
      end
    end
  end

  describe 'GET #new' do

    context 'ユーザーがログインしていない時、' do
      it '302がresponseされる' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        get :new, params: {lesson_id: @lesson}
        expect(response.code).to eq '302'
      end
    end

    context 'ユーザーがログインしている時、' do

      before do
        @user = create(:user)
        login_user(@user)
      end

      it '200がresponseされる' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        get :new, params: {lesson_id: @lesson}
        expect(response.code).to eq '200'
      end
    end
  end

  describe 'POST #create' do

    context 'ユーザーがログインしていない時、' do
      it '302がresponseされる' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        post :create, params: {lesson_id: @lesson}
        expect(response.code).to eq '302'
      end

      it 'Resultが登録されない' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        before_count = Result.count

        post :create, params: {lesson_id: @lesson,
            result: {
              grade: 'A',
              rep_1: 1,
              rep_2: 2,
              rep_3: 3,
              comment: 'これは楽しい授業です',
            }
          }
        expect(before_count).to eq Result.count
      end
    end

    context 'ユーザーがログインしている時、' do

      before do
        @user = create(:user)
        login_user(@user)
      end

      it 'Resultが一つ登録される' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        before_count = Result.count

        post :create, params: { lesson_id: @lesson,
            result: {
              grade: 'A',
              rep_1: 1,
              rep_2: 2,
              rep_3: 3,
              comment: 'これは楽しい授業です',
            }
          }
        expect(Result.count).to eq before_count + 1
      end

      context '正常にupdate出来た時、' do
        it '元のシラバスページに遷移する' do
          @lesson = build(:full_data_lesson)
          @lesson.save(validate: false)

          post :create, params: { lesson_id: @lesson,
              result: {
                grade: 'A',
                rep_1: 1,
                rep_2: 2,
                rep_3: 3,
                comment: 'これは楽しい授業です',
              }
            }
          expect(response).to redirect_to(lesson_path(@lesson))
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'ユーザーがログインしていない時、' do
      it '302がresponseされる' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        @result = Result.last

        put :update, params: { id: @result, lesson_id: @lesson}
        expect(response.code).to eq '302'
      end

      it 'Resultが更新されない' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        @result = Result.last
        before_comment = @result.comment

        put :update, params: { id: @result, lesson_id: @lesson,
            result: {
              grade: 'A',
              rep_1: 1,
              rep_2: 2,
              rep_3: 3,
              comment: "これは面白い授業です。#{Time.now}",
            }
          }
        expect(before_comment).to eq @result.comment
      end
    end

    context 'ユーザーがログインしている時、' do

      before do
        @user = create(:user)
        login_user(@user)
      end

      it 'Resultの数は増えない' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        @result = Result.last
        before_comment = @result.comment
        new_comment = "これは面白い授業です。#{Time.now}"

        expect do
          put :update, params: {id: @result.id, lesson_id: @result.lesson.id,
              result: {
                grade: 'A',
                rep_1: 1,
                rep_2: 2,
                rep_3: 3,
                comment: new_comment,
              }
            }
        end.to change(Result, :count).by(0)
      end

      it 'Resultの値が更新される' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        @result = Result.last
        before_comment = @result.comment
        new_comment = "これは面白い授業です。#{Time.now}"

        put :update, params: { id: @result.id, lesson_id: @result.lesson.id,
            result: {
              grade: 'A',
              rep_1: 1,
              rep_2: 2,
              rep_3: 3,
              comment: new_comment,
            }
          }
        @result.reload

        expect(before_comment == new_comment).to eq false
        expect(@result.comment).to eq new_comment
      end

      context '正常にupdate出来た時、' do
        it 'マイページに遷移する' do
          @lesson = build(:full_data_lesson)
          @lesson.save(validate: false)
          @result = Result.last
          before_comment = @result.comment
          new_comment = "これは面白い授業です。#{Time.now}"

          put :update, params: { id: @result.id, lesson_id: @result.lesson.id,
              result: {
                grade: 'A',
                rep_1: 1,
                rep_2: 2,
                rep_3: 3,
                comment: new_comment,
              }
            }
          expect(response).to redirect_to(lesson_result_index_path)
        end
      end
    end

  end

  describe 'DELETE #destroy' do
    context 'ユーザーがログインしていない時、' do
      it '302がresponseされる' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        @result = Result.last

        delete :destroy, params: { id: @result, lesson_id: @lesson }
        expect(response.code).to eq '302'
      end

      it 'Resultが削除されない' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        @result = Result.last

        expect do
          delete :destroy, params: { id: @result, lesson_id: @result.lesson.id }
        end.to change(Result, :count).by(0)
      end
    end

    context 'ユーザーがログインしている時、' do

      before do
        @user = create(:user)
        login_user(@user)
      end

      it 'Resultが削除される' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        @result = Result.last

        expect do
          delete :destroy, params: { id: @result, lesson_id: @result.lesson.id }
        end.to change(Result, :count).by(-1)
      end

      context '正常に削除された場合、' do
        it 'マイページに遷移する' do
          @lesson = build(:full_data_lesson)
          @lesson.save(validate: false)
          @result = Result.last

          delete :destroy, params: { id: @result, lesson_id: @result.lesson.id }

          expect(response).to redirect_to(lesson_result_index_path)
        end
      end
    end
  end

end
