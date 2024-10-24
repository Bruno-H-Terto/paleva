require 'rails_helper'

describe 'Usuário acessa o sistema' do
  context 'e preenche cadastro' do
    it 'com todos os campos válidos' do
      visit root_path
      within 'nav' do
        click_on 'Sou Proprietário'
      end
      click_on 'Não possui cadastro?'
      fill_in 'CPF', with: '91348691077'
      fill_in 'Nome', with: 'Ruby Dev'
      fill_in 'Sobrenome', with: 'TDD'
      fill_in 'E-mail', with: 'devs13@code.com'
      fill_in 'Senha', with: 'treina_dev13'
      fill_in 'Confirme sua senha', with: 'treina_dev13'
      click_on 'Criar conta'

      expect(page).to have_content 'Por favor, conclua seu cadastro'
      expect(current_path).to eq new_restaurant_path
    end

    it 'com campos ausentes' do
      visit root_path
      click_on 'Sou Proprietário'
      click_on 'Não possui cadastro?'
      fill_in 'CPF', with: ''
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''
      fill_in 'E-mail', with: 'devs13@code.com'
      fill_in 'Senha', with: 'treina_dev13'
      fill_in 'Confirme sua senha', with: 'treina_dev13'
      click_on 'Criar conta'

      expect(page).to have_css '.alert', text: 'Não foi possível salvar proprietário: 4 erros'
      expect(page).to have_content 'CPF não pode ficar em branco'
      expect(page).to have_content 'CPF não é um registro válido'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Sobrenome não pode ficar em branco'
    end

    it 'com CPF já registrado' do
      restaurant_owner = RestaurantOwner.create!(individual_tax_id: '91348691077', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')

      visit root_path
      click_on 'Sou Proprietário'
      click_on 'Não possui cadastro?'
      fill_in 'CPF', with: '91348691077'
      fill_in 'Nome', with: 'Ruby Dev'
      fill_in 'Sobrenome', with: 'TDD'
      fill_in 'E-mail', with: 'devs13@code.com'
      fill_in 'Senha', with: 'treina_dev13'
      fill_in 'Confirme sua senha', with: 'treina_dev13'
      click_on 'Criar conta'

      expect(page).to have_css '.alert', text: 'Não foi possível salvar proprietário: 1 erro'
      expect(page).to have_content 'CPF já está em uso'
    end

    it 'com senha inferior a 12 caracteres' do
      visit root_path
      click_on 'Sou Proprietário'
      click_on 'Não possui cadastro?'
      fill_in 'CPF', with: '91348691077'
      fill_in 'Nome', with: 'Ruby Dev'
      fill_in 'Sobrenome', with: 'TDD'
      fill_in 'E-mail', with: 'devs13@code.com'
      fill_in 'Senha', with: 'treina_dev1'
      fill_in 'Confirme sua senha', with: 'treina_dev1'
      click_on 'Criar conta'

      expect(page).to have_content 'Senha é muito curto (mínimo: 12 caracteres)'
    end

    it 'com CPF inválido' do
      visit root_path
      click_on 'Sou Proprietário'
      click_on 'Não possui cadastro?'
      fill_in 'CPF', with: '91348691011'
      fill_in 'Nome', with: 'Ruby Dev'
      fill_in 'Sobrenome', with: 'TDD'
      fill_in 'E-mail', with: 'devs13@code.com'
      fill_in 'Senha', with: 'treina_dev13'
      fill_in 'Confirme sua senha', with: 'treina_dev13'
      click_on 'Criar conta'

      expect(page).to have_content 'CPF não é um registro válido'
    end
  end
end