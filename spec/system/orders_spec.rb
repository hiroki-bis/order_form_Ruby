require 'rails_helper'

RSpec.describe "注文フォーム", type: :system do
  let(:name) {'サンプルマン'}
  let(:email) {'test@example.com'}
  let(:telephone) {'0312645787'}
  let(:delivery_address) {'東京都杉並区阿佐ヶ谷南一丁目 むつみ荘 201号室'}

  it '商品を注文できること' do
    #注文画面
    visit new_order_path #visitとすることでテストコードの中で実際にnew_order_path(注文フォーム)に訪れてくれる

    fill_in 'お名前', with: name #←サンプルマンが入る
    fill_in 'メールアドレス', with: email
    fill_in '電話番号', with: telephone
    fill_in 'お届け先住所', with: delivery_address
    select '銀行振込', from: '支払方法'  #←ラベル名で指定する

    click_on '確認画面へ' #←実際にボタン画面のを押してくれる

    #確認画面
    expect(current_path).to eq confirm_orders_path #current_pathは実際にテストコードで今のパス それがconfirm_orders_pathと同じかを確かめている

    click_on 'OK' #←実際に確認画面のOKボタン画面のを押してくれる

    #完了画面
    expect(current_path).to eq complete_orders_path #今のパスがcomplete_orders_pathと同じかを確かめている

    expect(page).to have_content "#{name}様" #pageは今のページの情報すべてが入っている have_contentとすることで "#{name}様"の文字列がページにあるかを確認している

    #完了画面をリロードすると注文画面に戻る仕様なので確認
    visit complete_orders_path
    expect(current_path).to eq new_order_path

    order = Order.last #今DBに登録されている最新のデータを取り出す
    expect(order.name).to eq name #サンプルマンになっていればOK
    expect(order.email).to eq email 
    expect(order.telephone).to eq telephone
    expect(order.delivery_address).to eq delivery_address
    expect(order.payment_method_id).to eq 2
  end

  context '入力情報に不備がある場合' do
    it '確認画面へ遷移することができない' do
      #注文画面
      visit new_order_path
  
      fill_in 'order_name', with: name #検証をみてidを指定してもOK
      fill_in 'メールアドレス', with: email
      fill_in '電話番号', with: '123456789012' #12桁にしてバリデーションに引っかける
      fill_in 'お届け先住所', with: delivery_address
      select '銀行振込', from: '支払方法'  #←ラベル名で指定する
  
      click_on '確認画面へ'
  
      #確認画面
      expect(current_path).to eq confirm_orders_path
      expect(page).to have_content '電話番号は11文字以内で入力してください' #バリデーションに引っかかっているか確認
    end

  context '確認画面で戻るを押した場合' do
      it '商品を注文できること' do
        #注文画面
        visit new_order_path
    
        fill_in 'お名前', with: name
        fill_in 'メールアドレス', with: email
        fill_in '電話番号', with: telephone
        fill_in 'お届け先住所', with: delivery_address
        select '銀行振込', from: '支払方法'  #←ラベル名で指定する
    
        click_on '確認画面へ'
    
        #確認画面
        expect(current_path).to eq confirm_orders_path
    
        click_on '戻る' #戻る
    
        #注文フォーム
        expect(current_path).to eq orders_path
    
        expect(page).to have_field 'お名前', with: name #have_fieldで各フィールド項目に入力した値がセットさせているか確認できる
        expect(page).to have_field 'メールアドレス', with: email
        expect(page).to have_field '電話番号', with: telephone
        expect(page).to have_field 'お届け先住所', with: delivery_address
        expect(page).to have_select '支払方法', selected: '銀行振込'
    
        click_on '確認画面へ'

        #確認画面
        expect(current_path).to eq confirm_orders_path

        click_on 'OK'

        #完了画面
        expect(current_path).to eq complete_orders_path
        expect(page).to have_content "#{name}様"

        #完了画面をリロードすると注文画面に戻る仕様なので確認
        visit complete_orders_path
        expect(current_path).to eq new_order_path
    
        order = Order.last #今DBに登録されている最新のデータを取り出す
        expect(order.name).to eq name #サンプルマンになっていればOK
        expect(order.email).to eq email 
        expect(order.telephone).to eq telephone
        expect(order.delivery_address).to eq delivery_address
        expect(order.payment_method_id).to eq 2
      end
    end

  end
end
