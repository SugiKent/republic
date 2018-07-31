require 'pry'
require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe '#has_results_include_past? T/Fが返る' do
    context "そのLessonにsame_lessonsがある時" do
      before do
        @lesson1 = build(:lesson)
        @lesson2 = build(:lesson)
        @lesson3 = build(:lesson)
        @lesson1.save(validate: false)
        @lesson2.save(validate: false)
        @lesson3.save(validate: false)

        @lesson1.same_lessons = "#{@lesson1.id},#{@lesson2.id},#{@lesson3.id}"
        @lesson2.same_lessons = "#{@lesson1.id},#{@lesson2.id},#{@lesson3.id}"
        @lesson3.same_lessons = "#{@lesson1.id},#{@lesson2.id},#{@lesson3.id}"

        @lesson1.save(validate: false)
        @lesson2.save(validate: false)
        @lesson3.save(validate: false)
      end
      context "そのLessonだけにレビューがある場合" do
        it "trueが返る" do
          r = Result.new(lesson_id: @lesson1.id)
          r.save(validate: false)
          expect(@lesson1.has_results_include_past?).to eq(true)
        end
      end
      context "そのLessonにレビューがなく、そのLessonを除いたsame_lessonsだけにレビューがある場合" do
        it "trueが返る" do
          r = Result.new(lesson_id: @lesson2.id)
          r.save(validate: false)
          expect(@lesson2.has_results_include_past?).to eq(true)
        end
      end
      context "そのLessonにも、same_lessonsにもレビューがない場合" do
        it "falseが返る" do
          expect(@lesson3.has_results_include_past?).to eq(false)
        end
      end
    end
  end

  describe "#get_relative_lessons 関連授業を返す" do
    context "引数が空の時" do
      it "全カリ && レビューのあるいずれかの授業に関連する授業が返る" do
        # 全カリ && レビューのある授業は必ず存在する前提
        lesson = Lesson.get_relative_lessons('').last
        expect([lesson.faculty_id, lesson.results.count>0]).to eq([11, true])
      end
    end

    context "引数にlessonが渡るとき" do
      before do
        @lesson1 = create(:lesson, :with_result, {
            department_id: 15,
            campus: 1,
            term: 1
          })
      end
      it "その授業と同じ学科・キャンパス・学期の授業で、レビューのあるものが返る" do
        lessons = Lesson.get_relative_lessons(@lesson1)
        # レビューがない授業の配列。空になるはず。
        zero_results_lessons = lessons.select{|lesson| lesson.results.count == 0}

        expect([lessons.pluck(:department_id).uniq, lessons.pluck(:campus).uniq, lessons.pluck(:term).uniq, zero_results_lessons]).to eq([[15], [1], [1], []])
      end
    end
  end

  describe "#visited_lessons 閲覧した授業を返す" do
    it "lesson_historyがないとfalseが返る" do
      expect(Lesson.visited_lessons( [], Lesson.find(200) )).to eq(false)
    end
    context "第二引数でLessonを指定したとき指定した場合" do
      it "第二引数で指定したLessonは返らない" do
        lessons = Lesson.visited_lessons([100, 200], Lesson.find(200))
        expect(lessons.map{ |l| l.id }).to eq([100])
      end
    end
    context "複数のlessonを第一引数に指定した場合" do
      it "第一引数の配列が逆順で返る" do
        lessons = Lesson.visited_lessons([100, 200, 300, 400, 500], Lesson.find(500))
        expect(lessons.map{ |l| l.id }).to eq([400, 300, 200, 100])
      end
    end
  end

  describe "#same_lessons_with_results same_lessonsを含めてレビューのある授業を取得" do
    context "引数が空の時" do
      it "空の配列が返る" do
        expect( Lesson.same_lessons_with_results([]) ).to eq([])
      end
    end

    context "引数のlessonsのsame_lessonsに、そのLessonしかない時" do
      before do
        @lesson1 = create(:lesson, :with_result)
        @lesson2 = create(:lesson, :with_result)
        @lesson3 = create(:lesson, :with_result)

        @lesson1.same_lessons = "#{@lesson1.id}"
        @lesson2.same_lessons = "#{@lesson2.id}"
        @lesson3.same_lessons = "#{@lesson3.id}"
        @lesson1.save(validate: false)
        @lesson2.save(validate: false)
        @lesson3.save(validate: false)
      end
      it "空の配列が返る" do
        lessons = Lesson.where(id: [@lesson1.id,@lesson2.id,@lesson3.id])

        expect( Lesson.same_lessons_with_results(lessons) ).to eq([])
      end
    end
    context "引数のlessonsのsame_lessonsに、複数のlessonのidがある場合" do
      before do
        @lesson1 = create(:lesson, :with_result)
        @lesson2 = create(:lesson, :with_result)
        @lesson3 = create(:lesson, :with_result)

        @lesson1.same_lessons = "#{@lesson1.id}, #{@lesson2.id}, #{@lesson3.id}"
        @lesson2.same_lessons = "#{@lesson1.id}, #{@lesson2.id}, #{@lesson3.id}"
        @lesson3.same_lessons = "#{@lesson1.id}, #{@lesson2.id}, #{@lesson3.id}"
        @lesson1.save(validate: false)
        @lesson2.save(validate: false)
        @lesson3.save(validate: false)
      end
      it "そのlessonsが返る" do
        lessons = Lesson.where(id: [@lesson1.id,@lesson2.id,@lesson3.id])

        expect( Lesson.same_lessons_with_results(lessons).count ).to eq(3)
      end
    end
  end

  describe 'scopeのテスト もう変わることのない2017年度の授業でテストする' do
    describe '#get_by_year' do
      context '2017年度で検索すると' do
        it '10303件のLessonが返る' do
          lessons = Lesson.get_by_year(2017)
          expect(lessons.count).to eq(10303)
        end
      end
    end
    describe '#get_by_content' do
      context '「哲学」で検索すると' do
        it '116件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_content('哲学')
          expect(lessons.count).to eq(116)
        end
      end
      context 'nilで検索すると' do
        it '10303件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_content(nil)
          expect(lessons.count).to eq(10303)
        end
      end
    end

    describe '#get_by_name' do
      context '「ビジネス」で検索すると' do
        it '73件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_name('ビジネス')
          expect(lessons.count).to eq(73)
        end
      end
      context 'nilで検索すると' do
        it '10303件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_name(nil)
          expect(lessons.count).to eq(10303)
        end
      end
    end

    describe '#get_by_proname' do
      context '「杉田」で検索すると' do
        it '3件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_proname('杉田')
          expect(lessons.count).to eq(3)
        end
      end
      context '「石川　文 也」で検索すると空白が除去されて、' do
        it '16件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_proname('石川　文 也')
          expect(lessons.count).to eq(16)
        end
      end
      context 'nilで検索すると' do
        it 'エラーする' do
          expect{ Lesson.get_by_year(2017).lesson_module_includes.get_by_proname(nil) }.to raise_error(NoMethodError)
        end
      end
    end

    describe '#get_by_campus' do
      context '「1」で検索すると' do
        it '6815件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_campus(1)
          expect(lessons.count).to eq(6815)
        end
      end
      context 'nilで検索すると' do
        it '0件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_campus(nil)
          expect(lessons.count).to eq(0)
        end
      end
    end

    describe '#get_by_faculty' do
      context '「12」で検索すると' do
        it '23件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_faculty(12)
          expect(lessons.count).to eq(23)
        end
      end
      context 'nilで検索すると' do
        it '0件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_faculty(nil)
          expect(lessons.count).to eq(0)
        end
      end
    end

    describe '#get_by_department' do
      context '「28」で検索すると' do
        it '322件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_department(28)
          expect(lessons.count).to eq(322)
        end
      end
      context 'nilで検索すると' do
        it '0件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_department(nil)
          expect(lessons.count).to eq(0)
        end
      end
    end

    describe '#get_by_term' do
      context '「1」で検索すると' do
        it '4799件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_term(1)
          expect(lessons.count).to eq(4799)
        end
      end
      context 'nilで検索すると' do
        it '7件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_term(nil)
          expect(lessons.count).to eq(7)
        end
      end
    end

    describe '#get_by_period' do
      context '「a」で検索すると' do
        it '1928件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_period('a')
          expect(lessons.count).to eq(1928)
        end
      end
      context '「a」と「3」で検索すると' do
        it '518件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_period('a').get_by_period('3')
          expect(lessons.count).to eq(518)
        end
      end
      context 'nilで検索すると' do
        it '10303件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_period(nil)
          expect(lessons.count).to eq(10303)
        end
      end
    end

    describe '#get_by_evaluation' do
      context '「75」で検索すると' do
        it '1178件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_evaluation('75')
          expect(lessons.count).to eq(1178)
        end
      end
      context 'nilで検索すると' do
        it '0件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.get_by_evaluation(nil)
          expect(lessons.count).to eq(0)
        end
      end
    end

    describe '#none_writing' do
      context '検索すると' do
        it '9911件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.none_writing
          expect(lessons.count).to eq(9911)
        end
      end
    end

    describe '#remove_word' do
      context '授業名の「入門」を取り除く検索すると' do
        it '9827件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.remove_word('入門', 'lesson_name')
          expect(lessons.count).to eq(9827)
        end
      end
      context '教授名の「石川」を取り除く検索すると' do
        it '10229件のLessonが返る' do
          lessons = Lesson.get_by_year(2017).lesson_module_includes.remove_word('石川', 'professor_name')
          expect(lessons.count).to eq(10229)
        end
      end
      context 'nilを渡すと' do
        it 'NG' do
          expect { Lesson.get_by_year(2017).lesson_module_includes.remove_word(nil, nil).count }.to raise_error(ActiveRecord::StatementInvalid)
        end
      end
    end

  end
end
