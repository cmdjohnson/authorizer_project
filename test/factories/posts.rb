Factory.define :post, :class => Post do |f|
  f.name "Hello"
  f.title "Hello"
  f.description "Lorem ipsum dolor sit amet..."
end

Factory.define :rant, :class => Rant, :parent => :post do |f|
end