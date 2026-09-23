namespace :employee_types do
  desc '従業員種別マスタの初期データを投入する（既存の同名種別は属性を上書き更新）'
  task seed: :environment do
    [
      {
        name: '看板娘',
        description: '明るい接客でお店の魅力と客足を伸ばしてくれる人気者。',
        hire_cost: 5000,
        attractiveness_bonus: 0.2,
        extra_customer_count: 3,
        bonus_customer_balance_multiplier: 1.5
      },
      {
        name: 'せり人',
        description: '目利きで仕入れ値を一律で安く抑えてくれる。',
        hire_cost: 3000,
        purchase_discount_rate: 0.03
      },
      {
        name: '敏腕バイヤー',
        description: '仮想のお客さんへの販売額を上乗せしてくれる。',
        hire_cost: 4000,
        virtual_sale_bonus_rate: 0.05
      }
    ].each do |attrs|
      employee_type = EmployeeType.find_or_initialize_by(name: attrs[:name])
      is_new = employee_type.new_record?
      employee_type.update!(attrs)
      puts "#{is_new ? '作成' : '更新'}: #{employee_type.name}"
    end

    puts "#{EmployeeType.count}件の従業員種別が登録されています。"
  end
end
