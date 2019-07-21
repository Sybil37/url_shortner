class ApplicationController < Sinatra::Base

    register Sinatra::ActiveRecordExtension
    
    configure do
      set :views, "app/views"
      set :public_dir, "public"
      enable :sessions
      set :session_secret, "secret"
    end

    get "/" do
        # @url = Url.find(:all, :order => "id desc", :limit => 5)
        @url = Url.all.order(id: :desc).limit(5)
        erb :homepage
    end

    get "/registrations/signup" do
        erb :'registrations/signup'
    end  

    post "/registrations" do
         user = User.create(user_name: params["name"], email_address: params["email"]) 
         user.password = params["password"]
         user.save
         session[:user_id] = user.id
         redirect "/users/home"

    end

    get "/sessions/login" do
        erb :'sessions/login'

    end

    post "/sessions" do
         user = User.find_by(email_address: params["email"])
         if user.password == params["password"]
            session[:user_id] = user.id
            redirect "/users/home"
         else
            redirect "/sessions/login"
         end

    end


#This route generates a url and saves it to the database if the url doesn't already exist in the database else it creates a new one with the user_id as the current user_id if the user is logged in.
    post "/url" do
        search = Url.find_by(user_url: params["url"])
        if search.nil? == true
           user =  User.find(user_id: session[:user_id])
            if user.nil? == true
               a = (rand(100..400) + 1).to_s
               @url = Url.create(user_url: params["url"], gen_url: "#{a}" )
               erb :"/shortened"
            else
                @url = Url.create(user_id: session[:user_id], gen_url: "#{a}")
                erb :"/shortened"
            end
        else
            @url = Url.find_by(user_url: params["url"]) 
            erb :'shortened'
        end
        # a = (rand(100..400) + 1).to_s
        # search = User.find(session[:user_id])
        # if session[:user_id] == search.id
        #     @url = Url.new(user_url: params["url"], user_id: session[:user_id], gen_url: "#{a}")
        #     @url.save
        #     erb :"/shortened"

        # else
        #     @url = Url.new(user_url: params["url"], gen_url: "#{a}")
        #     @url.save
        #     erb :"/shortened"

        # end
        # @url = Url.new(user_url: params["url"], user_id: session[:user_id], gen_url: "#{a}")
        # @url.save
    end

    get "/sessions/logout" do
        session.clear
        redirect "/"

    end



    get "/:gen_url" do
        url = Url.find_by(gen_url: params[:gen_url])
        # byebug
        redirect url.user_url
    end

    get "/users/home" do 
        @user = User.find(session[:user_id])
        erb :"/users/home"
    end

    get "/users" do
        @name = User.where(session[:user_id])
        @url = Url.where(session[:user_id]).pluck(:gen_url)
        redirect "users/user_urls"


    end



    # post "/url" do
    #     a = (rand(1..9) + 1).to_s 
    #     b = (rand(1..9) + 2).to_s
    #     c = rand(1..9).to_s

    #      @user = User.find_by(session[:user_id])
    #     if session[:user_id] == user.user_id
    #         create = Url.create(user_url: params["url"], user_id: params[session[:user_id]], gen_url: ["https:// + #{a} + #{b} + #{c}"])
    #        d = Url.find_by(session[:user_id])
    #         @show_url = d.gen_url
    #         redirect "/users/url"
    #     else
    #         erb :shortened
    #     end
    # end
end