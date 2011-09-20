module Topcgen
  module JAVA
    def self.combine *statements
      MultipleGen.new statements
    end

    def self.newline
      BlankGen.new
    end

    def self.val(type, value)
      type_is_array = !(/\[\]$/ =~ type).nil?
      value_is_array = value.instance_of? Array
      if value_is_array && !type_is_array
        raise "non-array type '#{type}' encountered for array value '#{value}'"
      end
      ValueGen.new type, value
    end

    def self.var(type, name, value=nil)
      VariableGen.new type, name, value
    end

    def self.pkg(path)
      PackageGen.new path
    end

    def self.import(path, object='*', static=false)
      object = '*' if object.nil?
      static = false if static.nil?
      ImportGen.new path, object, static
    end

    def self.ctor(type)
      NewGen.new type
    end

    def self.arr(type, value, length=0)
      type = type.gsub(/\[\]$/, "")
      value_gen = (value.instance_of? Array) ? ValueGen.new("#{type}[]", value) : value
      NewArrayGen.new type, value_gen, length
    end

    def self.comment(text)
      CommentGen.new text
    end

    def self.call(name, *args)
      FunCallGen.new name, args
    end

    def self.ret(value)
      ReturnGen.new value
    end

    def self.default(type)
      case type
      when 'int'
        ValueGen.new 'int', 0
      when 'long'
        ValueGen.new 'long', 0
      when 'double'
        ValueGen.new 'double', 0.0
      else  
        'null'
      end
    end

    def self.annotation(text)
      AnnotationGen.new text
    end

    def self.method(name, return_type, parameters, statements, annotation=nil, comment=nil, visibility='public')
      parameters = [] if parameters.nil?
      statements = [] if statements.nil?
      MethodGen.new name, return_type, parameters, statements, annotation, comment, visibility
    end

    def self.clas(name, fields, methods, comments=nil, visibility='public')
      comments = [] if comments.nil?
      fields = [] if fields.nil?
      methods = [] if methods.nil?
      ClassGen.new name, fields, methods, comments, visibility
    end
  end
end
