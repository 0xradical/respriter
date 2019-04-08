describe 'I18nHelper' do

  it 'returns nil when locale is nil' do
    expect(I18nHelper.sanitize_locale(nil)).to be_nil
  end

  it 'returns nil when locale is blank' do
    expect(I18nHelper.sanitize_locale('')).to be_nil
  end

  it 'returns the root locale as a symbol' do
    expect(I18nHelper.sanitize_locale('pt')).to eq(:pt)
  end

  it 'always returns region locale upcased and symbolized' do
    expect(I18nHelper.sanitize_locale('pt-br')).to eq(:'pt-BR')
  end

end
