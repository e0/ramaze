#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'lib/test/test_helper'

include Ramaze

class TCRequestController < Template::Ramaze
  def is_post()   request.post?.to_s end
  def is_get()    request.get?.to_s end
  def is_put()    request.put?.to_s end
  def is_delete() request.delete?.to_s end

  def request_inspect
    request.params.inspect
  end

  def post_inspect
    request.params.inspect
  end

  def put_inspect(file)
    request.params['PUT'].inspect
  end

  def get_inspect
    request.params.inspect
  end

  def my_ip
    request.remote_addr
  end
end

context "Request" do
  context "POST" do
    ramaze( :adapter => :webrick, :mapping => {'/' => TCRequestController} )

    specify "give me the result of request.post?" do
      post("is_post").should == 'true'
    end

    specify "give me the result of request.get?" do
      post("is_get").should == 'false'
    end

    # this here has shown some odd errors... keep an eye on it.
    specify "give me back what i gave" do
      post("post_inspect", 'this' => 'post').should == {"this" => "post"}.inspect
    end
  end

  context "PUT" do
    specify "put a ressource" do
      address = "http://localhost:7007/put_inspect/#{CGI.escape(__FILE__)}"
      response = `curl -S -s -T #{__FILE__} #{address}`
      file = File.read(__FILE__)

      response[1..-2].should == file
    end
  end

  context "DELETE" do
    specify "delete a ressource" do
      # find a way to test this one, even curl doesn't support it
    end
  end

  context "GET" do
    specify "give me the result of request.post?" do
      get("/is_post").should == 'false'
    end

    specify "give me the result of request.get?" do
      get("/is_get").should == 'true'
    end

    specify "give me back what i gave" do
      get("/get_inspect?one=two&three=four").should == {'one' => 'two', 'three' => 'four'}.inspect
    end

    specify "my ip" do
      get("/my_ip").should == '127.0.0.1'
    end
  end
end
