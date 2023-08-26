class OrdersController < ApplicationController
    def new
        @order = Order.new
    end

    def confirm
        @order = Order.new(order_params)

        #バリデーションに失敗したらinvalidがTrueになる
        return render :new if @order.invalid?
    end

    def create
        @order = Order.new(order_params)
        return render :new if params[:button] == 'back'
        if @order.save
            session[:order_id] = @order.id
            return redirect_to complete_orders_url 
        end

        render :confirm
    end

    def complete
        #ここでセッションの注文者idから注文者情報を取得
        @order = Order.find_by(id: session[:order_id])
        #もし注文者情報がなかったら注文画面にリダイレクト
        return redirect_to new_order_url if @order.blank?
        #セキュリティ上なるベくセッション情報を長持ちするとよくないので速やかに破棄する
        session[:order_id] = nil
    end

    private

    def order_params
        params
        .require(:order)
        .permit(:name,
                :email,
                :telephone,
                :delivery_address,
                :payment_method_id)
    end
end