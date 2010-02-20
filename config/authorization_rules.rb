authorization do
  role :admin do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages, :users], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :excel, :voice, :mapping, :cron]
  end

  role :normal do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show, :excel, :voice, :voices]
  end
end
