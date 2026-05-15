SitemapGenerator::Sitemap.default_host = "https://mtdavid.com.pe"

SitemapGenerator::Sitemap.create do
  add "/", changefreq: "daily", priority: 1.0
end
