require 'pry'
require 'rails_helper'

RSpec.describe Result, type: :model do
  before do
    @lesson = create(:lesson)
    @user = create(:user)
  end

  describe 'バリデーション' do
    it 'grade以外が埋まっているとOK' do
      @result = build(:blank_result, {
        lesson_id: @lesson.id,
        user_id: @user.id,
        comment: '最高の授業です',
        score: 3,
        rep_1: 1,
        rep_2: 2,
        rep_3: 3,
      })
      expect(@result.valid?).to eq(true)
    end

    it 'lesson_idがないとNG' do
      @result = build(:blank_result, {
        user_id: @user.id,
        comment: '最高の授業です',
        score: 3,
        rep_1: 1,
        rep_2: 2,
        rep_3: 3,
      })
      expect(@result.valid?).to eq(false)
    end

    it 'user_idがないとNG' do
      @result = build(:blank_result, {
        lesson_id: @lesson.id,
        comment: '最高の授業です',
        score: 3,
        rep_1: 1,
        rep_2: 2,
        rep_3: 3,
      })
      expect(@result.valid?).to eq(false)
    end

    it 'commentがなくてもOK' do
      @result = build(:blank_result, {
        lesson_id: @lesson.id,
        user_id: @user.id,
        score: 3,
        rep_1: 1,
        rep_2: 2,
        rep_3: 3,
      })
      expect(@result.valid?).to eq(true)
    end

    it 'scoreがないとNG' do
      @result = build(:blank_result, {
        lesson_id: @lesson.id,
        user_id: @user.id,
        comment: '最高の授業です',
        rep_1: 1,
        rep_2: 2,
        rep_3: 3,
      })
      expect(@result.valid?).to eq(false)
    end

    context 'scoreが0~4以外の場合' do
      it '-1だとNG' do
        @result = build(:blank_result, {
          lesson_id: @lesson.id,
          user_id: @user.id,
          comment: '最高の授業です',
          score: -1,
          rep_1: 1,
          rep_2: 2,
          rep_3: 3,
        })
        expect(@result.valid?).to eq(false)
      end
      it '5だとNG' do
        @result = build(:blank_result, {
          lesson_id: @lesson.id,
          user_id: @user.id,
          comment: '最高の授業です',
          score: 5,
          rep_1: 1,
          rep_2: 2,
          rep_3: 3,
        })
        expect(@result.valid?).to eq(false)
      end
    end

    it 'rep_1がないとNG' do
      @result = build(:blank_result, {
        lesson_id: @lesson.id,
        user_id: @user.id,
        comment: '最高の授業です',
        score: 3,
        rep_2: 2,
        rep_3: 3,
      })
      expect(@result.valid?).to eq(false)
    end

    it 'rep_2がないとNG' do
      @result = build(:blank_result, {
        lesson_id: @lesson.id,
        user_id: @user.id,
        comment: '最高の授業です',
        score: 3,
        rep_1: 1,
        rep_3: 3,
      })
      expect(@result.valid?).to eq(false)
    end

    it 'rep_3がないとNG' do
      @result = build(:blank_result, {
        lesson_id: @lesson.id,
        user_id: @user.id,
        comment: '最高の授業です',
        score: 3,
        rep_1: 1,
        rep_2: 2,
      })
      expect(@result.valid?).to eq(false)
    end
  end
end
