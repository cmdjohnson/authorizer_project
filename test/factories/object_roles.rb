# -*- encoding : utf-8 -*-
Factory.define :object_role, :class => ObjectRole do |f|
  f.klazz_name "Post"
  f.object_reference 1
  f.association :user
  f.role ObjectRole.roles.first
end
