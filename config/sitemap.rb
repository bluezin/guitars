SitemapGenerator::Sitemap.default_host = "https://mtdavid.com.pe"

SitemapGenerator::Sitemap.create do
  add "/", changefreq: "daily", priority: 1.0
  add "/historical-overview", changefreq: "monthly", priority: 0.6
  add "/contact", changefreq: "monthly", priority: 0.5

  I18n.available_locales.each do |locale|
    add "/#{locale}", changefreq: "daily", priority: 1.0
    add "/#{locale}/historical-overview", changefreq: "monthly", priority: 0.6
    add "/#{locale}/contact", changefreq: "monthly", priority: 0.5

    Product.find_each do |product|
      add "/#{locale}/products/#{product.id}", changefreq: "weekly", priority: 0.8, lastmod: product.updated_at
    end
  end
end
