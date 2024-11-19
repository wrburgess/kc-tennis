require 'rails_helper'

describe ActionButton::Component, type: :component do
  include_context 'component_setup'

  describe '#render' do
    let(:link) { create(:link) }

    before do
      # @request.env['devise.mapping'] = Devise.mappings[:user]
      # sign_in(user)
    end

    it 'renders a cancel_to_index action button' do
      component = described_class.new(operation: :cancel_to_index, instance: link, public: true)
      render_inline(component)

      expect(page).to have_text('Cancel')
      expect(page).to have_link(nil, href: '/admin/links')
      expect(page).to have_css('.btn-secondary')
      expect(page).to have_css('.bi-x-octagon')

      link = page.find('a', text: 'Cancel')
      method_attribute = link['data-method']

      expect(method_attribute).to eq('get')
    end

    it 'renders a cancel_to_show action button' do
      component = described_class.new(operation: :cancel_to_show, instance: link, public: true)
      render_inline(component)

      expect(page).to have_text('Cancel')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}")
      expect(page).to have_css('.btn-secondary')
      expect(page).to have_css('.bi-x-octagon')

      link = page.find('a', text: 'Cancel')
      method_attribute = link['data-method']

      expect(method_attribute).to eq('get')
    end

    it 'renders a copy action button' do
      component = described_class.new(operation: :copy, instance: link)
      render_inline(component)

      expect(page).to have_text('Create Duplicate link')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}/copy")
      expect(page).to have_css('.btn-success')
      expect(page).to have_css('.bi-front')

      link = page.find('a', text: 'Create Duplicate link')
      method_attribute = link['data-method']

      expect(method_attribute).to eq('post')
    end

    it 'renders a new action button' do
      component = described_class.new(operation: :new, instance: link)
      render_inline(component)

      expect(page).to have_text('Create New link')
      expect(page).to have_link(nil, href: '/admin/links/new')
      expect(page).to have_css('.btn-success')
      expect(page).to have_css('.bi-plus-circle')

      link = page.find('a', text: 'Create New link')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders an edit action button' do
      component = described_class.new(operation: :edit, instance: link)
      render_inline(component)

      expect(page).to have_text('Edit')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}/edit")
      expect(page).to have_css('.btn-warning')
      expect(page).to have_css('.bi-pencil')

      link = page.find('a', text: 'Edit')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders an edit action link' do
      component = described_class.new(operation: :edit, instance: link, button_classes: :none, icon_classes: :none)
      render_inline(component)

      expect(page).to have_text('Edit')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}/edit")
      expect(page).to_not have_css('.btn-warning')
      expect(page).to_not have_css('.bi-pencil')

      link = page.find('a', text: 'Edit')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders an export xlsx action button' do
      component = described_class.new(operation: :export_xlsx, instance: link)
      render_inline(component)

      expect(page).to have_text('Download')
      expect(page).to have_link(nil, href: '/admin/links/export_xlsx')
      expect(page).to have_css('.btn-info')
      expect(page).to have_css('.bi-file-spreadsheet')

      link = page.find('a', text: 'Download')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders a destroy action button' do
      component = described_class.new(operation: :destroy, instance: link)
      render_inline(component)

      expect(page).to have_text('Delete')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}")
      expect(page).to have_css('.btn-danger')
      expect(page).to have_css('.bi-x-circle')

      link = page.find('a', text: 'Delete')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('delete')
    end

    it 'renders an index action button' do
      component = described_class.new(operation: :index, instance: link)
      render_inline(component)

      expect(page).to have_text('View List')
      expect(page).to have_link(nil, href: '/admin/links')
      expect(page).to have_css('.btn-primary')
      expect(page).to have_css('.bi-list-ul')

      link = page.find('a', text: 'View List')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders a show action button' do
      component = described_class.new(operation: :show, instance: link)
      render_inline(component)

      expect(page).to have_text('View')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}")
      expect(page).to have_css('.btn-info')
      expect(page).to have_css('.bi-eyeglasses')

      link = page.find('a', text: 'View')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders a show action link' do
      component = described_class.new(operation: :show, instance: link, button_classes: :none, icon_classes: :none)
      render_inline(component)

      expect(page).to have_text('View')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}")
      expect(page).to_not have_css('.btn-warning')
      expect(page).to_not have_css('.bi-pencil')

      link = page.find('a', text: 'View')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders a user_export_xlsx action link' do
      component = described_class.new(operation: :user_export_xlsx, instance: link)
      render_inline(component)

      expect(page).to have_text('Download')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}/user_export_xlsx")
      expect(page).to_not have_css('.btn-warning')
      expect(page).to_not have_css('.bi-pencil')

      link = page.find('a', text: 'Download')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders a user_export_xlsx action button' do
      component = described_class.new(operation: :user_export_xlsx, instance: link)
      render_inline(component)

      expect(page).to have_text('Download')
      expect(page).to have_link(nil, href: "/admin/links/#{link.id}/user_export_xlsx")
      expect(page).to have_css('.btn-info')
      expect(page).to have_css('.bi-file-spreadsheet')

      link = page.find('a', text: 'Download')
      method_attribute = link['data-method']
      expect(method_attribute).to eq('get')
    end

    it 'renders a button with overrides' do
      custom_text = Faker::Lorem.word
      custom_path = Faker::Internet.url
      custom_method = Faker::Lorem.word
      component = described_class.new(operation: :new, instance: link, method: custom_method, path: custom_path, text: custom_text, button_classes: 'btn btn-test', classes_append: 'm-2', icon_classes: 'bi bi-test')
      render_inline(component)

      expect(page).to have_text(custom_text)
      expect(page).to have_link(nil, href: custom_path)
      expect(page).to have_css('.btn-test')
      expect(page).to have_css('.bi-test')
      expect(page).to have_css('.m-2')

      link = page.find('a', text: custom_text)
      method_attribute = link['data-method']
      expect(method_attribute).to eq(custom_method)
    end

    it 'renders a button as authorized despite non-sanctioned operation' do
      custom_text = Faker::Lorem.word
      custom_path = Faker::Internet.url
      custom_method = Faker::Lorem.word
      custom_operation = Faker::Lorem.word.to_sym
      component = described_class.new(operation: custom_operation, instance: link, method: custom_method, path: custom_path, text: custom_text, button_classes: 'btn btn-test', classes_append: 'm-2', icon_classes: 'bi bi-test', public: true)
      render_inline(component)

      expect(page).to have_text(custom_text)
      expect(page).to have_link(nil, href: custom_path)
      expect(page).to have_css('.btn-test')
      expect(page).to have_css('.bi-test')
      expect(page).to have_css('.m-2')

      link = page.find('a', text: custom_text)
      method_attribute = link['data-method']
      expect(method_attribute).to eq(custom_method)
    end

    it 'renders a button as unauthorized' do
      custom_text = Faker::Lorem.word
      custom_path = Faker::Internet.url
      custom_method = Faker::Lorem.word
      custom_operation = Faker::Lorem.word.to_sym
      component = described_class.new(operation: custom_operation, instance: link, method: custom_method, path: custom_path, text: custom_text, button_classes: 'btn btn-test', classes_append: 'm-2', icon_classes: 'bi bi-test', public: false)
      render_inline(component)

      expect(page).to_not have_text(custom_text)
      expect(page).to_not have_css('.btn-test')
      expect(page).to_not have_css('.bi-test')
      expect(page).to_not have_css('.m-2')
    end
  end
end
