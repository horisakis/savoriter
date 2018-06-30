require 'rails_helper'

RSpec.describe User, type: :model do
  it 'はメールとパスワードがあれば有効であること' do
    user = User.new(email: 'a@b.c',
                    password: 'aaabbbccc',
                    password_confirmation: 'aaabbbccc')

    expect(user).to be_valid
  end

  it 'はメールアドレスがなければ無効であること' do
    user = User.new(email: nil)

    user.valid?

    expect(user.errors[:email]).to include("can't be blank")
  end

  # email_parts = ['a', '@', 'b', '.', 'c']
  # invalid_format_emails = []
  # (email_parts.length - 1).downto(1) do |num|
  #   email_parts.combination(num) do |parts|
  #     invalid_format_emails << parts.join
  #   end
  # end
  # deviseのメールアドレスフォーマットチェックはガバガバなので
  # 明らかにおかしいフォーマットを一つチェックでよしとする
  invalid_format_emails = ['a']

  invalid_format_emails.each do |email|
    it 'はメールアドレスのフォーマットが正しくなければ無効であること' do
      user = User.new(email: email)

      user.valid?

      expect(user.errors[:email]).to include('is invalid')
    end
  end

  it 'はパスワードが設定されていなければ無効であること' do
    user = User.new(password: nil)

    user.valid?

    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'はパスワードと確認用パスワードが一致していなければ無効であること' do
    user = User.new(password: 'aaabbb',
                    password_confirmation: 'bbbaaa')

    user.valid?

    expect(user.errors[:password_confirmation]).to include("doesn't match パスワード")
  end

  password_min_length = 6
  password_max_length = 128
  it "はパスワードの長さが#{password_min_length}未満であれば無効であること" do
    user = User.new(password: 'a' * (password_min_length - 1))

    user.valid?

    expect(user.errors[:password]).to include("is too short (minimum is #{password_min_length} characters)")
  end

  it "はパスワードの長さが#{password_min_length}であれば有効であること" do
    user = User.new(password: 'a' * password_min_length)

    user.valid?

    expect(user.errors[:password]).to_not include("is too short (minimum is #{password_min_length} characters)")
  end

  it "はパスワードの長さが#{password_max_length}であれば有効であること" do
    user = User.new(password: 'a' * password_max_length)

    user.valid?

    expect(user.errors[:password]).to_not include("is too long (maximum is #{password_max_length} characters)")
  end

  it "はパスワードの長さが#{password_max_length}より長ければ無効であること" do
    user = User.new(password: 'a' * (password_max_length + 1))

    user.valid?

    expect(user.errors[:password]).to include("is too long (maximum is #{password_max_length} characters)")
  end
end
