require 'pry'
require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  describe 'バリデーション' do
    it "emailが空だとNG" do
      @user.email = ''
      expect(@user.valid?).to eq(false)
    end

    it "emailのドメインがrikkyoのじゃないとNG" do
      @user.email = '13bn016t@meiji.ac.jp'
      expect(@user.valid?).to eq(false)
    end

    it "emailの前半が立教生のフォーマットでないとNG" do
      @user1 = build(:user)
      @user2 = build(:user)
      @user3 = build(:user)
      @user4 = build(:user)
      @user5 = build(:user)


      @user1.email = '1bn016t@rikkyo.ac.jp'
      @user2.email = '15bn06t@rikkyo.ac.jp'
      @user3.email = '16bn016@rikkyo.ac.jp'
      @user4.email = '17bn016at@rikkyo.ac.jp'
      @user5.email = '18b016t@rikkyo.ac.jp'

      expect(@user1.valid?).to eq(false)
      expect(@user2.valid?).to eq(false)
      expect(@user3.valid?).to eq(false)
      expect(@user4.valid?).to eq(false)
      expect(@user5.valid?).to eq(false)
    end

    it "アカウント登録後に学部と学科が結びつく" do
      @user.email = '13bn016t@rikkyo.ac.jp'
      @user.save
      expect([@user.faculty_id, @user.department_id]).to eq([3,15])
    end
  end

  describe "#first_grade?" do
    context "入学した年の12月31日までは" do
      around do |e|
        travel_to('2018-12-31 23:59'){ e.run }
      end
      it "trueが返る" do
        current_year = 18
        @user.email = "#{current_year}bn016t@rikkyo.ac.jp"
        expect(@user.first_grade?).to eq(true)
      end
    end

    context "入学した翌年の1月1日からは" do
      around do |e|
        travel_to('2019-01-01 00:01'){ e.run }
      end
      it "falseが返る" do
        current_year = 18
        @user.email = "#{current_year}bn016t@rikkyo.ac.jp"
        expect(@user.first_grade?).to eq(false)
      end
    end
  end
end
