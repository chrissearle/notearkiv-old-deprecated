Factory.define :composer do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :genre do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :period do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :user do |f|
  f.username "foo"
  f.name "Foo McFoo"
  f.sequence(:email) { |n| "foo_#{n}@example.com" }
  f.password "foofoo2"
  f.password_confirmation  { |u| u.password }
end

Factory.define :role do |f|
  f.name "Foo"
end