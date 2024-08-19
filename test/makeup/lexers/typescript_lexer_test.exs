defmodule Makeup.Lexers.TypescriptLexerTest do
  use ExUnit.Case

  alias Makeup.Lexers.TypescriptLexer

  test "works" do
    assert TypescriptLexer.lex("""
           const foo: Foo

           const bar = () => undefined

           function baz (param: number): number {
            return param + 5;
           }


           """)
  end

  test "lexes class with constructor" do
    assert [
             {:keyword_declaration, %{language: :ts}, ~c"class"},
             {:whitespace, %{language: :ts}, " "},
             {:keyword_type, %{language: :ts}, ~c"SomeClass"},
             {:whitespace, %{language: :ts}, " "},
             {:punctuation, %{group_id: curly, language: :ts}, "{"},
             {:whitespace, %{language: :ts}, "\n "},
             {:name_function, %{language: :ts}, ~c"constructor"},
             {:punctuation, %{group_id: parens, language: :ts}, "("},
             {:punctuation, %{group_id: parens, language: :ts}, ")"},
             {:whitespace, %{language: :ts}, " "},
             {:punctuation, %{group_id: curly_2, language: :ts}, "{"},
             {:whitespace, %{language: :ts}, "\n   "},
             {:keyword_reserved, %{language: :ts}, ~c"this"},
             {:punctuation, %{language: :ts}, "."},
             {:name, %{language: :ts}, ~c"foo"},
             {:whitespace, %{language: :ts}, " "},
             {:operator, %{language: :ts}, "="},
             {:whitespace, %{language: :ts}, " "},
             {:string, %{language: :ts}, ["\"", 98, 97, 114, "\""]},
             {:punctuation, %{language: :ts}, ";"},
             {:whitespace, %{language: :ts}, "\n "},
             {:punctuation, %{group_id: curly_2, language: :ts}, "}"},
             {:whitespace, %{language: :ts}, "\n"},
             {:punctuation, %{group_id: curly, language: :ts}, "}"},
             {:whitespace, %{language: :ts}, "\n"}
           ] =
             TypescriptLexer.lex("""
             class SomeClass {
              constructor() {
                this.foo = "bar";
              }
             }
             """)
  end

  test "lexes types in extends statement" do
    assert [
             {:keyword_type, %{language: :ts}, 84},
             {:whitespace, %{language: :ts}, " "},
             {:keyword_reserved, %{language: :ts}, ~c"extends"},
             {:whitespace, %{language: :ts}, " "},
             {:keyword_type, %{language: :ts}, ~c"number"}
           ] = TypescriptLexer.lex("T extends number")

    assert [
             {:keyword_type, %{language: :ts}, 84},
             {:whitespace, %{language: :ts}, " "},
             {:keyword_reserved, %{language: :ts}, ~c"extends"},
             {:whitespace, %{language: :ts}, " "},
             {:punctuation, %{language: :ts, group_id: _}, "("},
             {:punctuation, %{language: :ts, group_id: _}, ")"},
             {:whitespace, %{language: :ts}, " "},
             {:operator, %{language: :ts}, "="},
             {:punctuation, %{language: :ts}, ">"},
             {:whitespace, %{language: :ts}, " "},
             {:operator_word, %{language: :ts}, ~c"void"}
           ] = TypescriptLexer.lex("T extends () => void")

    assert [
             {:keyword_type, %{language: :ts}, 84},
             {:whitespace, %{language: :ts}, " "},
             {:keyword_reserved, %{language: :ts}, ~c"extends"},
             {:whitespace, %{language: :ts}, " "},
             {:number_integer, %{language: :ts}, "1"}
           ] = TypescriptLexer.lex("T extends 1")
  end
end
