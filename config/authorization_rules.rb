authorization do
  role :siteadmin do
    has_permission_on [:notes, :evensongs, :users, :stats], :to => [:index]
  end

  role :admin do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :voice]
  end

  role :normal do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show]
  end
end
