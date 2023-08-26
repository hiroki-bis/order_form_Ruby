class EmailFormatValidator < ActiveModel::EachValidator #ActiveModel::EachValidator これは何？
    def validate_each(record, attribute, value) #recordはorderのインスタンス attributeはバリデートを設定した時の属性 valueが検証する値
        return if /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(value)
        #match()で文字列が\ \の間の条件に合っていたらTrueを返す
        #"[\w+\-.]"の部分がアカウントパターン1⃣　"[a-z\d\-.]+\.[a-z]"の部分がドメインパターン2⃣
        #ドメインは"."でつながった文字列になるはずなので"\."とする。.だけだと正規表現にあるので\を付ける
        #ドメインの"[a-z]+"の部分は、comに該当するところ　[a-z]でa~zまでの小文字1文字、"+"とすることで左の条件が１文字以上続くという意味
        #"[a-z\d\-.]+"の/dは数字0~9、\-でハイフン有、.で.有([]の中の.は\いらない)
        #アカウント部分で"/w"の部分は、a~z0~9と_がOKという意味
        #\A \z両サイドのこれは、これに囲まれた文字から始まり、終わりも囲まれた条件に一致しないとダメという意味　他の言語だと"^ $"のような書き方もする
        #一番最後の"i"は大文字、小文字を問わないという意味
        #正規表現を忘れた場合は　https://rubular.com/　がおすすめ
        
        #※scanというメソッドもあって　'starting star'.scan(/star/)=>['star','star']のように一致した文字を配列で取り出すメソッドもある
        record.errors.add(attribute, 'の形式が正しくありません')
    end
end

#上のクラスをバリデーションとして使用する場合には、クラス名の"Validator"を除いた部分を「EmailFormat」スネークケースで書く→"email_format"