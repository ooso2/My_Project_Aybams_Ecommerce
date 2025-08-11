class PagesController < ApplicationController
  def show
    @page = Page.published.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Page not found.'
  end

  def about
    @page = Page.published.find_by(slug: 'about') || Page.new(title: 'About Us', content: 'Welcome to AYBAMS!')
  end

  def contact
    @page = Page.published.find_by(slug: 'contact') || Page.new(title: 'Contact Us', content: 'Get in touch with us!')
  end
end