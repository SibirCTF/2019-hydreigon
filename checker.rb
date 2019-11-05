#!/usr/bin/ruby
# frozen_string_literal: true

require 'net/https'
require 'securerandom'
require 'redis'

class DataChecker
  def self.worked
    exit(101)
  end

  def self.corrupt
    exit(102)
  end

  def self.mumble
    exit(103)
  end

  def self.down
    exit(104)
  end

  def self.ua
    chrome = rand(3000..4000)
    firefox = rand(60..70)
    apple_web_kit = "#{rand(500..600)}.#{rand(10..40)}"
    @ua ||= [
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/#{apple_web_kit} (KHTML, like Gecko) Chrome/76.0.#{chrome}.133 Safari/#{apple_web_kit}",
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/#{apple_web_kit} (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A",
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:#{firefox}.0) Gecko/20100101 Firefox/#{firefox}.0",
      "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/#{apple_web_kit} (KHTML, like Gecko) Chrome/41.0.#{chrome}.0 Safari/537.3",
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/#{apple_web_kit} (KHTML, like Gecko) Chrome/76.0.#{chrome}.143 Safari/#{apple_web_kit}",
      "Mozilla/5.0 (X11; U; Linux i686) AppleWebKit/#{apple_web_kit} (KHTML, like Gecko) Chrome/75.0.#{chrome}.90 Safari/#{apple_web_kit}",
      "Mozilla/5.0 (X11; Ubuntu; Linux; rv:#{firefox}.0) Gecko/20100101 Firefox/#{firefox}.0"
    ].sample
  end
end

class ResourceChecker
  attr_reader :host
  attr_reader :ua
  attr_reader :message
  attr_reader :password
  attr_reader :redis

  def initialize(password:, message:, host:)
    @redis = Redis.new(url: 'redis://10.218.255.13:6379')
    @ua = DataChecker.ua
    @host = "https://#{host}:2300/"
    @message = message
    @password = password
  end

  def check?
    available?

    tmp_remote_url = redis.get(password)

    uri = URI.parse(host + "messages/#{tmp_remote_url}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.path, 'User-Agent' => ua)
    res = https.request(request)
    crypto_response = res.body
    crypto_note = crypto_response.split('textarea')[1].split('"')[-1][1..-3]
    enc = encrypt_message(crypto_note, password)
    return DataChecker.corrupt unless enc
    return DataChecker.mumble unless enc == message

    DataChecker.worked
  rescue StandardError
    DataChecker.corrupt
  end

  def put?
    available?

    tmp_remote_url = remote_url
    redis.set(password, tmp_remote_url)
    return DataChecker.corrupt if tmp_remote_url == false

    check?
  rescue StandardError
    DataChecker.corrupt
  end

  private

  def remote_url
    payload = {
      'message[text]' => message,
      'message[clicks_left]' => rand(10..20),
      'message[self_destruction_time]' => (Time.now + 89_000),
      'message[client_password]' => password
    }
    res = send_post_request(host + 'messages', payload)
    /[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/.match(res.body)[0]
  rescue StandardError
    false
  end

  def encrypt_message(message, password)
    payload = {
      'message[text]' => message,
      'message[client_password]' => password
    }
    send_post_request(host + 'crypto', payload).body
  rescue StandardError
    false
  end

  def available?
    main_page = send_get_request_and_check_body(host, 'Hydreigon')
    DataChecker.down unless main_page
    analitycs_available = send_get_request_and_check_body(host + '66d9b558f41b30033e4d62bf47d52885e31627e4/payloads', ua)
    DataChecker.corrupt unless analitycs_available
  end

  def send_post_request(url, payload)
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.path)
    req['User-Agent'] = ua
    req.set_form_data(payload)
    https.request(req)
  end

  def send_get_request_and_check_body(host, body_include)
    uri = URI.parse(host)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.path, 'User-Agent' => ua)
    res = https.request(request)
    if res.body.include?(body_include)
      true
    else
      false
    end
  rescue StandardError
    false
  end
end

ip_address = ARGV[0] || '127.0.0.1'
command = ARGV[1] || 'check'
flag_id = ARGV[2] || '1234567890' || (0..10).map { rand(65..90).chr }.join
flag = ARGV[3] || 'c10bb4f1-83e5-4ff6-8d8b-1866f2662cc4' || SecureRandom.uuid

rc = ResourceChecker.new(password: flag_id, message: flag, host: ip_address)
case command
when 'check'
  rc.check?
when 'put'
  rc.put?
end
