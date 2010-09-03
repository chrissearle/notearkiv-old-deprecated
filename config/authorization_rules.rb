authorization do
  role :siteadmin do
    has_permission_on [:users], :to => [:index, :show, :new, :create, :edit, :update]
    has_permission_on [:stats], :to => [:index]
    has_permission_on [:session_caches], :to => [:authorize]
  end

  role :import do
    has_permission_on [:notes_upload, :evensongs_upload], :to => [:upload, :import]
  end

  role :admin do
    has_permission_on [:notes], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :voice]
    has_permission_on [:evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:archive], :to => [:download]
  end

  role :account do
    has_permission_on [:account], :to => [:index, :edit, :update]
  end

  role :normal do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show]
    has_permission_on [:archive], :to => [:download]
  end
end
