require 'pry'
require 'rails_helper'

RSpec.describe Classes::LessonController, type: :controller do
  describe 'GET #index' do
    before do
      get :index
    end
    it '200がresponseされる' do
      expect(response.code).to eq '200'
    end
  end

  describe 'GET #search' do
    it '200がresponseされる' do
      get :search
      expect(response.code).to eq '200'
    end

    context '全項目が検索されているとき' do
      # scopeのテストはmodelのテストに
      let(:params) { { lesson_name: '演習',
          professor_name: '石川',
          content: '心理・行動',
          year: 2018,
          campus: 1,
          faculty_id: 3,
          department_id: 15,
          term: 1,
          day: 'e',
          hour: 4,
          evaluation: 0
         } }

      it '200がresponseされる' do
        get :search, params: params
        expect(response.code).to eq '200'
      end
      it '1件の@lessonsが返る' do
        get :search, params: params
        expect(controller.instance_variable_get("@lessons").length).to eq 1
      end
    end
  end

  describe 'GET #show' do
    context 'Lessonのデータが揃っている時' do
      it '200がresponseされる' do
        @lesson = build(:full_data_lesson)
        @lesson.save(validate: false)
        get :show, params: {id: @lesson}
        expect(response.code).to eq '200'
      end
    end
    context 'Lesson + LessonDetailのデータが揃っている時' do
      it '200がresponseされる' do
        @lesson = create(:full_data_lesson, :with_lesson_detail, :with_lesson_schedules)
        get :show, params: {id: @lesson}
        expect(response.code).to eq '200'
      end
    end

    context 'Lesson + LessonDetail + LessonScheduleのデータが揃っている時' do
      it '200がresponseされる' do
        @lesson = create(:full_data_lesson, :with_lesson_detail, :with_lesson_schedules)
        get :show, params: {id: @lesson}
        expect(response.code).to eq '200'
      end
    end

    context 'Lesson + LessonDetail + LessonSchedule + Evaluationのデータが揃っている時' do
      it '200がresponseされる' do
        @lesson = create(:full_data_lesson, :with_lesson_detail, :with_lesson_schedules, :with_evaluations)
        get :show, params: {id: @lesson}
        expect(response.code).to eq '200'
      end
    end

    context 'Lesson + LessonDetail + LessonSchedule + Evaluation + TextBookのデータが揃っている時' do
      it '200がresponseされる' do
        @lesson = create(:full_data_lesson, :with_lesson_detail, :with_lesson_schedules, :with_evaluations, :with_textbooks)
        get :show, params: {id: @lesson}
        expect(response.code).to eq '200'
      end
    end

    context 'Lesson + LessonDetail + LessonSchedule + Evaluation + TextBookが紐づいて、それぞれデータが最低限揃っている場合' do
      it '200がresponseされる' do
        @lesson = create(:minimum_data_lesson)
        get :show, params: {id: @lesson}
        expect(response.code).to eq '200'
      end
    end
  end
end
