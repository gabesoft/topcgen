module Topcgen
  module JAVA
    def self.combine *statements
      Multiple.new statements
    end

    def self.newline
      Blank.new
    end

    def self.val(type, value)
      Value.new type, value
    end

    def self.var(type, name, value=nil)
      Variable.new type, name, value
    end

    def self.pkg(path)
      Package.new path
    end

    def self.import(path, object='*', static=false)
      object = '*' if object.nil?
      static = false if static.nil?
      Import.new path, object, static
    end

    def self.ctor(type)
      New.new type
    end

    def self.arr(type, value, length=0)
      type = type.gsub(/\[\]$/, "")
      value_gen = (value.instance_of? Array) ? Value.new("#{type}[]", value) : value
      NewArray.new type, value_gen, length
    end

    def self.comment(text)
      Comment.new text
    end

    def self.call(name, *args)
      FunCall.new name, args
    end

    def self.ret(value)
      Return.new value
    end

    def self.default(type)
      case type
      when 'int'
        Value.new 'int', 0
      when 'long'
        Value.new 'long', 0
      else  
        'null'
      end
    end

    def self.annotation(text)
      Annotation.new text
    end

    def self.method(name, return_type, parameters, statements, annotation=nil, comment=nil, visibility='public')
      parameters = [] if parameters.nil?
      statements = [] if statements.nil?
      Method.new name, return_type, parameters, statements, annotation, comment, visibility
    end

    def self.clas(name, fields, methods, comments=nil, visibility='public')
      comments = [] if comments.nil?
      fields = [] if fields.nil?
      methods = [] if methods.nil?
      Class.new name, fields, methods, comments, visibility
    end
  end
end
