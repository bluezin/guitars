SitemapGenerator::Sitemap.default_host = "https://mtdavid.com.pe"

SitemapGenerator::Sitemap.create do
  def hreflang_alternates(path)
    I18n.available_locales.map do |loc|
      { lang: loc.to_s, href: "https://mtdavid.com.pe/#{loc}#{path}" }
    end + [{ lang: "x-default", href: "https://mtdavid.com.pe/es#{path}" }]
  end

  add "/", changefreq: "daily", priority: 1.0, alternates: hreflang_alternates("")
  add "/historical-overview", changefreq: "monthly", priority: 0.6, alternates: hreflang_alternates("/historical-overview")
  add "/contact", changefreq: "monthly", priority: 0.5, alternates: hreflang_alternates("/contact")

  Product.find_each do |product|
    path = "/products/#{product.id}"
    add "/#{path}", changefreq: "weekly", priority: 0.8, lastmod: product.updated_at, alternates: hreflang_alternates(path)
  end
end
