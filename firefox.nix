

    programs.kdeconnect.enable = true;

    programs.firefox = {
      enable = true;
      policies = {
        DisableFirefoxStudies = true;
        DisablePocket = true;
        Preferences = {
          "browser.compactmode.show".Value = true;
          "browser.quitShortcut.disabled".Value = true; # Disable CTRL-Q
          "browser.urlbar.suggest.calculator".Value = true;
          "extensions.quarantinedDomains.enabled".Value = false;
        };
      };
    };
browser.startup.homepage	moz-extension://97f63812-65e2-4484-a8fb-f58cf7a914b6/index.html

browser.uiCustomization.state
{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action","_ed387cfb-e57a-49e0-9bf3-017a1f7f2378_-browser-action","_531906d3-e22f-4a6c-a102-8057b88a1a63_-browser-action","_contain-facebook-browser-action","extension_one-tab_com-browser-action","gt_giphy_com-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","juraj_masiar_gmail_com_scrollanywhere-browser-action","_0d28e91e-0540-46e0-9f78-84bcdb32567c_-browser-action","firefox-extension_shodan_io-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button","unified-extensions-button","_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action","private-relay_firefox_com-browser-action","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","simple-translate_sienori-browser-action","jid0-dsq67mf5kjjhiiju2dfb6kk8dfw_jetpack-browser-action","_f07d92af-9c8a-43fe-b7ac-736a862ce495_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action","_ed387cfb-e57a-49e0-9bf3-017a1f7f2378_-browser-action","_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action","_531906d3-e22f-4a6c-a102-8057b88a1a63_-browser-action","private-relay_firefox_com-browser-action","_contain-facebook-browser-action","extension_one-tab_com-browser-action","addon_darkreader_org-browser-action","gt_giphy_com-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","ublock0_raymondhill_net-browser-action","juraj_masiar_gmail_com_scrollanywhere-browser-action","_0d28e91e-0540-46e0-9f78-84bcdb32567c_-browser-action","firefox-extension_shodan_io-browser-action","simple-translate_sienori-browser-action","jid0-dsq67mf5kjjhiiju2dfb6kk8dfw_jetpack-browser-action","_f07d92af-9c8a-43fe-b7ac-736a862ce495_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar"],"currentVersion":20,"newElementCount":2}


extensions.webextensions.uuids
{"formautofill@mozilla.org":"b76e709f-5d78-4c5b-8aa7-64f7e3852994","pictureinpicture@mozilla.org":"5984caaa-898d-46df-8d55-e1bc4448366e","screenshots@mozilla.org":"a85a659a-12bb-4fcd-ba99-084917739988","webcompat-reporter@mozilla.org":"bfdbe2a2-fe51-44a5-9bdd-f3aa38dbb755","webcompat@mozilla.org":"59d262ea-5799-4e1a-9b4b-7ce5711936f1","default-theme@mozilla.org":"1b918bbf-26d5-40cf-b95d-04e7b6b7cc42","addons-search-detection@mozilla.com":"17db46ba-ecba-4a72-b3b5-2fcb5685e4f9","{ed387cfb-e57a-49e0-9bf3-017a1f7f2378}":"d41cc8a9-da1b-4494-b57e-993e4cb605fa","{20fc2e06-e3e4-4b2b-812b-ab431220cada}":"4fa06b49-ffad-495c-8169-c2060cb2f88f","{531906d3-e22f-4a6c-a102-8057b88a1a63}":"88bc793e-45ea-4082-9ad2-f184c1f3e355","private-relay@firefox.com":"d75438fa-8cd8-4959-9b28-b11332296beb","{1018e4d6-728f-4b20-ad56-37578a4de76b}":"45a2bb84-cae9-4068-a7d5-2c7153e142ff","@contain-facebook":"5ec196e9-d06c-4c85-88b3-4f749a59fa02","extension@one-tab.com":"1b32219e-87e4-4d23-918f-3e657d18e992","addon@darkreader.org":"70a319f5-2e3f-4616-8cd1-288a6bbdc6c2","extension@tabliss.io":"97f63812-65e2-4484-a8fb-f58cf7a914b6","gt@giphy.com":"9ff3b348-1196-4eb9-961e-0d76ad2deecf","jid1-BoFifL9Vbdl2zQ@jetpack":"3ebc128d-b856-4cdb-8435-9c47965eee2b","uBlock0@raymondhill.net":"d140366f-2749-4ead-a63a-39b0a0a5903c","juraj.masiar@gmail.com_ScrollAnywhere":"180e2080-3144-436f-ba0b-d355e03c755e","{0d28e91e-0540-46e0-9f78-84bcdb32567c}":"22fedd43-318b-4d68-9fe8-7a57d088f712","markdown-a11y-checker@iansan5653":"15a493d7-8c0e-4c24-9e49-d8d2001f165b","firefox-extension@shodan.io":"532f301e-4d9d-4283-b738-a9eeb2ac4f55","simple-translate@sienori":"805fe0da-20f0-4059-98d0-b90ac4e0dffd","google@search.mozilla.org":"bd29f82e-9d9d-4f60-86dd-1c128afb5f1f","wikipedia@search.mozilla.org":"4ab7cf95-b0a5-497b-adf3-8a8751a4145b","bing@search.mozilla.org":"7bf5d9f1-7acb-4381-b1b4-f1c566f1df2d","ddg@search.mozilla.org":"e641daef-7332-4249-bf8f-8fcf9429e859","{3bd4f6ac-272c-47da-b288-3706cea55b12}":"7c016540-0426-4c73-8a78-ba07cd29f032","quizletbypass@rospino74.github.io":"c6660d45-c536-4a7d-a3de-c340237df965","{f07d92af-9c8a-43fe-b7ac-736a862ce495}":"05955308-78ca-4d2f-90c1-1c709dcef5b2"}

browser.pageActions.persistedActions	{"ids":["bookmark","_1018e4d6-728f-4b20-ad56-37578a4de76b_"],"idsInUrlbar":["_1018e4d6-728f-4b20-ad56-37578a4de76b_","bookmark"],"idsInUrlbarPreProton":[],"version":1}
