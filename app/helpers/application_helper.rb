module ApplicationHelper
  def shallow_args(parent, child)
    params[:action] == 'new' ? [parent, child] : child
  end

  def amp_ready?
    defined?(@amp_ready) && @amp_ready == true
  end

  def default_meta_tags
    {
      site: 'Rep',
      separator: '',
      title: '立教大学シラバス検索システム',
      description: 'もうみんな使ってる！圧倒的に使いやすいシラバス検索で、履修の組みやすさが劇的にアップ！立教生のあなたの強い味方に。立教生があなたのために書いた授業のレビューもあります。Repは立教大学の授業シラバス情報を収集し、見やすく、探しやすいシラバス検索を実現しました。立教生のみなさん、ぜひご利用ください！',
      keywords: '立教大学, シラバス, 授業, 履修, 楽単',
      canonical: '',
      og: {
        title: :title,
        type: 'website',
        url: 'https://www.rep-rikkyo.com/',
        image: image_url('rep-white.png'),
        site_name: :site,
        description: :description,
        locale: 'ja_JP'
      },
      twitter: {
        title: :title,
        site: '@rep_rikkyo',
        card: 'summary',
        description: :description,
        image: image_url('rep-white.png'),
        url: :url
      }
    }
  end

  def hbr(str)
    str = html_escape(str)
    str.gsub(/\r\n|\r|\n|¥n/, '<br />').html_safe
  end
end
