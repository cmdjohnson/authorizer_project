# -*- encoding : utf-8 -*-
Factory.define :object_role, :class => ObjectRole do |f|
  f.class_name "Hello"
  f.object_reference 1
  f.user 
  f.role "Hello"
end
