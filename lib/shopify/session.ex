defmodule Shopify.Session do
  alias Shopify.Config
  
  defstruct [
    :type,
    :shop_name,
    :api_key,
    :password,
    :base_url,
    :access_token,
    :client_id,
    :client_secret,
    headers: []
  ]

  def new(:oauth, {shop_name, access_token}) do
    %Shopify.Session{
      type: :oauth,
      shop_name: shop_name,
      access_token: access_token,
      headers: ["X-Shopify-Access-Token": access_token,
                "Content-Type": "application/json"],
      base_url: "https://#{shop_name}.myshopify.com/admin/",
    }
  end

  def new(:oauth, shop_name) do
    %Shopify.Session{
      type: :oauth,
      shop_name: shop_name,
      headers: ["Content-Type": "application/json"],
      base_url: "https://#{shop_name}.myshopify.com/admin/",
      client_id: Config.get(:client_id),
      client_secret: Config.get(:client_secret)
    }
  end

  def new(:basic, {shop_name, api_key, password}) do
    %Shopify.Session{
      type: :basic,
      shop_name: shop_name,
      api_key: api_key,
      password: password,
      headers: ["Content-Type": "application/json"],
      base_url: "https://#{api_key}:#{password}@#{shop_name}.myshopify.com/admin/"
    }
  end

  def new, do: new(:basic, Config.basic_auth)
end