authorization do
  role :siteadmin do
    has_permission_on [:users], :to => [:index, :show, :new, :create, :edit, :update]
    has_permission_on [:stats], :to => [:index]
  end

  role :admin do
    has_permission_on [:notes], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :voice]
    has_permission_on [:evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  role :account do
    has_permission_on [:account], :to => [:index, :edit, :update]
  end

  role :normal do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show]
  end
end
