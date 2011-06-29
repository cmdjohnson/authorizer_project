# -*- encoding : utf-8 -*-
Factory.define :user, :class => User do |f|
  f.email { |e| u = User.last; "user#{u.nil? ? 1 : (u.id+1)}@example.com" }
  f.password "test123"
  f.password_confirmation "test123"
end
