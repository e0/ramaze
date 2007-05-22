#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'spec/helper'

class TCControllerController < Ramaze::Controller
  map '/'
  template_root 'spec/ramaze/template/ezamar'

  def index
    @text = "World"
  end

  def sum first, second
    @num1, @num2 = first.to_i, second.to_i
  end

  def some__long__action
  end

  def another__long__action
  end

  private

  def test_private
  end
end

describe "Controller" do
  def handle(*args)
    Ramaze::Controller.handle(*args)
  end

  def resolve(*args)
    Ramaze::Controller.resolve(*args)
  end

  def values(*url)
    resolve(*url).last.values_at(:method, :params, :template)
  end

  before :all do
    ramaze :error_page => false
    @hash = {
      '/' => [
        ["/", 'index', []]
      ],

      '/foo' => [
        ["/foo", 'index',[]],
        ['/',    'foo',  []],
        ["/",    'index', ["foo"]],
      ],

      '/foo/bar' => [
        ["/foo__bar", "index",    []],
        ["/foo/bar",  "index",    []],

        ["/foo",      "bar",      []],
        ["/foo",      "index",    ["bar"]],

        ["/",         "foo__bar", []],
        ["/",         "foo",      ["bar"]],
        ["/",         "index",    ["foo", "bar"]],
      ],

      '/foo/bar/baz' => [

        ['/foo__bar__baz', 'index',         []],
        ['/foo/bar/baz',   'index',         []],

        ['/foo__bar',      'baz',           []],
        ['/foo__bar',      'index',         ['baz']],

        ['/foo/bar',       'baz',           []],
        ['/foo/bar',       'index',         ['baz']],

        ['/foo',           'bar__baz',      []],
        ['/foo',           'bar',           ['baz']],
        ['/foo',           'index',         ['bar', 'baz']],

        ['/',              'foo__bar__baz', []],
        ['/',              'foo__bar',      ['baz']],
        ['/',              'foo',           ['bar', 'baz']],
        ['/',              'index',         ['foo', 'bar', 'baz']],
      ],

      '/foo/bar/baz/oof' => [
        ['/foo__bar__baz__oof', 'index',               []],

        ['/foo/bar/baz/oof',    'index',               []],

        ['/foo__bar__baz',      'oof',                 []],
        ['/foo__bar__baz',      'index',               ['oof']],

        ['/foo/bar/baz',        'oof',                 []],
        ['/foo/bar/baz',        'index',               ['oof']],

        ['/foo__bar',           'baz__oof',            []],
        ['/foo__bar',           'baz',                 ['oof']],
        ['/foo__bar',           'index',               ['baz', 'oof']],

        ['/foo/bar',            'baz__oof',            []],
        ['/foo/bar',            'baz',                 ['oof']],
        ['/foo/bar',            'index',               ['baz', 'oof']],

        ['/foo',                'bar__baz__oof',       []],
        ['/foo',                'bar__baz',            ['oof']],
        ['/foo',                'bar',                 ['baz', 'oof']],
        ['/foo',                'index',               ['bar', 'baz', 'oof']],

        ['/',                   'foo__bar__baz__oof',  []],
        ['/',                   'foo__bar__baz',       ['oof']],
        ['/',                   'foo__bar',            ['baz', 'oof']],
        ['/',                   'foo',                 ['bar', 'baz', 'oof']],
        ['/',                   'index',               ['foo', 'bar', 'baz', 'oof']],
      ]
    }
  end

  it "dry pattern_for" do
    @hash.each do |path, correct|
      patterns = Ramaze::Controller.pattern_for(path)
      patterns.should == correct
    end
  end

  it '/' do
    values('/').should ==
      ['index', [], 'spec/ramaze/template/ezamar/index.zmr']
  end

  it '/sum/1/2' do
    values('/sum/1/2').should ==
      ['sum', ['1', '2'],'spec/ramaze/template/ezamar/sum.zmr']
  end

  it '/another/long/action' do
    values('/another/long/action').should ==
      ['another__long__action', [], 'spec/ramaze/template/ezamar/another/long/action.zmr']
  end
  it '/some/long/action' do
    values('/some/long/action').should ==
      ['some__long__action', [], 'spec/ramaze/template/ezamar/some__long__action.zmr']
  end

  it "simple request to index" do
    handle('/').should == 'Hello, World!'
  end

  it "summing two values" do
    handle('/sum/1/2').should == '3'
  end

  it "double underscore in templates" do
    handle('/some/long/action').should == 'some long action'
    handle('/another/long/action').should == 'another long action'
  end

  TCControllerController.private_methods.sort.each do |action|
    it action do
      path = "/#{action}"
      message = "No Action found for `#{path}' on TCControllerController"
      lambda{ resolve(path) }.should raise_error(Ramaze::Error::NoAction, message)
    end
  end
end
