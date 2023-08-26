require 'nkf'

class Order < ApplicationRecord
    #↓payment_methodテーブルをOrderテーブルの子テーブルにする
    belongs_to :payment_method
    validates :name, presence:true, length: { maximum: 40}
    #presence:trueとすることで空を禁止にする
    validates :email, presence:true, length: { maximum: 100}, email_format: true #独自バリデーションの設定
    validates :telephone, presence:true, length: { maximum: 11}, numericality: { only_integer: true}
    validates :delivery_address, presence:true, length: { maximum: 100}
    #コールバックを使いすぎるとかえってコードが複雑化してしまうので注意すること

    #コントローラーでパラメータを受け取ってモデルが作られた直後に、このafter_initializeが実行される
    #このafter_initializeはコールバックの1つであらかじめ用意されているもの
    after_initialize :format_telephone
    after_initialize :format_email

    #コールバックのメソッドを作成してバリデートの前にデータを整える
    private

    def format_telephone
        # if telephone.present?
        return if telephone.blank?
            #deleteはその文字があったら除外するという意味だが、^を付けると"!"と同じように逆の意味になる
            self.telephone = telephone.tr('０-９', '0-9').delete('^0-9')
        # end
    end

    def format_email
        return if email.blank?
        self.email = NKF.nkf('-w -Z4', email)
    end

    #アプリ独自のバリデーション↓
    # validate :email_format

    # private
    # #アプリ独自のバリデーションは↓のようにして追加できる
    # def email_format
    #     return if /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(email)
    #     #match()で文字列が\ \の間の条件に合っていたらTrueを返す
    #     #"[\w+\-.]"の部分がアカウントパターン1⃣　"[a-z\d\-.]+\.[a-z]"の部分がドメインパターン2⃣
    #     #ドメインは"."でつながった文字列になるはずなので"\."とする。.だけだと正規表現にあるので\を付ける
    #     #ドメインの"[a-z]+"の部分は、comに該当するところ　[a-z]でa~zまでの小文字1文字、"+"とすることで左の条件が１文字以上続くという意味
    #     #"[a-z\d\-.]+"の/dは数字0~9、\-でハイフン有、.で.有([]の中の.は\いらない)
    #     #アカウント部分で"/w"の部分は、a~z0~9と_がOKという意味
    #     #\A \z両サイドのこれは、これに囲まれた文字から始まり、終わりも囲まれた条件に一致しないとダメという意味　他の言語だと"^ $"のような書き方もする
    #     #一番最後の"i"は大文字、小文字を問わないという意味
    #     #正規表現を忘れた場合は　https://rubular.com/　がおすすめ
        
    #     #※scanというメソッドもあって　'starting star'.scan(/star/)=>['star','star']のように一致した文字を配列で取り出すメソッドもある
    #     errors.add(:email, 'の形式が正しくありません')
    # end
end