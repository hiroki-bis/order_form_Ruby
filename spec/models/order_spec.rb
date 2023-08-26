require 'rails_helper'
#以下はrspecのテストコードの書き方
RSpec.describe Order, type: :model do #ここでmodelのOrderクラスのテストですよと明記する
  describe '#valid?' do #メソッドごとにテストコードを記述する(validというメソッド)インスタンスメソッドは# クラスメソッドは.を最初に記述する
    let(:name) {'サンプルマン'}
    let(:email) {'test@example.com'}
    let(:telephone) {'0312645787'}
    let(:delivery_address) {'東京都杉並区阿佐ヶ谷南一丁目 むつみ荘 201号室'}
    let(:payment_method_id) {1}
    let(:params) do
      {
        name:,
        email:,
        telephone:,
        delivery_address:,
        payment_method_id:
        #このようなハッシュは本当は、name: name,のように書くが、項目とハッシュのキーの名前が同じ場合は省略できる
      }
    end

    # it '返り値はtureになること' do
    #   order = Order.new(params) #ここのparamsが↑の9~16行目のもの
    #   expect(order.valid?).to eq true #order.validを実行して期待値がtrueと一致していればOKというもの eqは==と同じ意味
    # end

    #ここが具体的にテストをしているコード
    subject{ Order.new(params).valid? }

    it{ is_expected.to eq true }

    context '名前が空白の場合' do
    let(:name) {''}

    it{ is_expected.to eq false }
    end

    context 'メールアドレスが空白の場合' do
      let(:email) {''}

      it{ is_expected.to eq false }
    end

    context 'メールアドレスの書式が正しくないの場合' do
      let(:email) {'tesuto.com'}

      it{ is_expected.to eq false }
    end

    context 'メールアドレスが全角の場合' do
      let(:email) {'ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ'}

      it{ is_expected.to eq true } #コールバックを設定しているので、半角になりtrueになる
    end

    context '電話番号が空白の場合' do
      let(:telephone) {''}

      it{ is_expected.to eq false }
    end

    context '電話番号が全角の場合' do
      let(:telephone) {'９０７８４３５７８'}

      it{ is_expected.to eq true }#コールバックを設定しているので、半角になりtrueになる
    end

    context '電話番号に数字以外が含まれている場合' do
      let(:telephone) {'032-4542-4525'}

      it{ is_expected.to eq true }#コールバックを設定しているので、半角になりtrueになる
    end

    context '電話番号が12桁の場合' do
      let(:telephone) {'012345678912'}

      it{ is_expected.to eq false }
    end

    context 'お届け先住所が空白の場合' do
      let(:delivery_address) {''}

      it{ is_expected.to eq false }
    end

    context '支払い方法が未入力の場合' do
      let(:payment_method_id) { nil }

      it{ is_expected.to eq false }
    end
      
  end
end
