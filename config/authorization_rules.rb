authorization do
  role :siteadmin do
    has_permission_on [:notes, :evensongs, :users], :to => [:index, :cron]
  end

  role :admin do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :excel, :voice]
  end

  role :normal do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show, :excel, :voice, :voices]
  end
end
