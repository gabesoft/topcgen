module Topcgen
  module JAVA
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
      Import.new path, object, static
    end

    def self.ctor(type)
      New.new type
    end

    def self.arr(type, value, length=0)
      value = Value.new("#{type}[]", value) if !value.nil? && (value.instance_of? Array)
      type = type.gsub(/\[\]$/, "")
      NewArray.new type, value, length
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

    def self.method(name, return_type, annotation, comment, parameters, statements, visibility='public')
      Method.new name, return_type, annotation, comment, parameters, statements, visibility
    end

    def self.clas(name, comments, fields, methods, visibility='public')
      comments = [] if comments.nil?
      fields = [] if fields.nil?
      methods = [] if methods.nil?
      Class.new name, comments, fields, methods, visibility
    end
  end
end
