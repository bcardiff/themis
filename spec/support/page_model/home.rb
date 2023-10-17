class Home < SitePrism::Page
  set_url '/'

  element :room_link, 'a', text: 'tomar asistencia'
end
