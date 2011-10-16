module Topcgen
  module JAVA
    def self.main_class(stream, package, method_def, info)
      gen_package(stream, package.main_package)
      gen_main_imports(stream, info[:main_imports])
      gen_main_class(stream, method_def, info)
    end

    def self.test_class(stream, package, method_def, info, tests)
      gen_package(stream, package.test_package)
      gen_test_imports(stream, info[:test_imports], package)
      gen_test_class(stream, method_def, info, tests)
    end

    private

    def self.gen_test_imports(stream, imports, package)
      imports = imports.clone()
      imports.push({ :path => package.main_package })
      gen_imports stream, imports
    end

    def self.gen_test_class(stream, method_def, info, tests)
      delta = var 'double', 'DELTA', (val 'double', 0.000000001)
      field = var info[:name], info[:name].downcase, (ctor info[:name])

      args_def = method_def.parameters
      return_type = method_def.return_type
      return_type_is_array = !(/\[\]$/ =~ return_type).nil?
      return_type_is_double = (return_type == 'double' || return_type == 'double[]')

      assert_name = return_type_is_array ? 'assertArrayEquals' : 'assertEquals'
      actual_arguments = args_def.map { |p| p[:name] }
      actual = call "#{info[:name].downcase}.#{method_def.name}", *actual_arguments
      test_annotation = annotation 'Test'

      methods = tests.each_with_index.map do |t, i|
        name = "case#{i + 1}"
        args = t[:arguments]

        statements = args_def.zip(args).map { |a, v| var a[:type], a[:name], (val a[:type], v) }

        expected = return_type_is_array ? arr(return_type, t[:expected]) : val(return_type, t[:expected])
        absolute_error = return_type_is_array || expected.value == 0
        assert_error = absolute_error ? delta.name : binop('*', delta.name, expected)
        assert_arguments = return_type_is_double ? [ expected, actual, assert_error] : [ expected, actual ]
        assert_call = call assert_name, *assert_arguments

        statements.push assert_call
        test_method = method(name, 'void', nil, statements, test_annotation)
        combine test_method, newline
      end

      test_class_name = "#{info[:name]}Test"
      test_class_fields = return_type_is_double ? [ delta, field ] : [ field ]
      test_class = clas test_class_name, test_class_fields, methods
      test_class.gen stream
    end

    def self.gen_package(stream, package_path)
      package_gen = pkg package_path
      package_gen.gen stream
      newline.gen stream
    end

    def self.gen_main_imports(stream, imports)
      gen_imports stream, imports
    end

    def self.gen_imports(stream, imports)
      imports.each do |i|
        import_gen = import i[:path], i[:object], i[:static]
        import_gen.gen stream
      end
      newline.gen stream if imports.length > 0;
    end

    def self.gen_main_class(stream, method_def, info)
      comments = [
        comment(info[:used_in] + ' ' + info[:used_as] + ' - ' + info[:point_value]),
        comment(info[:categories].downcase),
        comment("statement: #{info[:statement_link_full]}"),
        comment("editorial: #{info[:editorial_link_full]}") ]

        return_type = method_def.return_type
        return_statement = ret (default return_type)
        main_method = method(method_def.name, return_type, method_def.parameters, [ return_statement ])
        debug_method = get_debug_method

        class_gen = clas(info[:name], nil, [ main_method, newline, debug_method ], comments)
        class_gen.gen stream
    end

    def self.get_debug_method
      argument = 'os'
      statement = call 'System.out.println', (call 'Arrays.deepToString', argument)
      parameter = { :type => 'Object...', :name => argument }
      method 'debug', 'void', [ parameter ], [ statement ], nil, nil, 'private'
    end

  end
end
