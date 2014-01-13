require 'jruby_cxf'

class Animal
  include CXF::ComplexType

  member :kind, :string

  namespace 'http://opensourcesoftwareandme.blogspot.com'
end

class Person
  include CXF::ComplexType

  member :name, :string
  member :age, :int
  member :pet, :Animal, :required => false

  namespace 'http://opensourcesoftwareandme.blogspot.com'

end

class HelloWorld
  include CXF::WebServiceServlet

  expose :say_hello, {:expects => [{:person => :Person}], :returns => :string}
  expose :give_age, {:expects => [{:person => :Person}], :returns => :string}

  service_name 'MyExample'
  service_namespace 'http://opensourcesoftwareandme.blogspot.com'

  def say_hello(person)
    return 'Hello ' + person.name
  end

  def give_age(person)
    return 'Your age is ' + person.age.to_s
  end

end