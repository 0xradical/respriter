<template>
  <side-menu :num-of-items="2">
    <template #side-menu-item-1>
      <span class="el:m-label">
        <icon name="profile" class="el:m-label__icon el:amx-Mr(0.75em)"></icon>
        <span class="el:m-label__text el:amx-Fs(0.875em)">
          {{ $t("user.side_menus.account_settings.profile") }}
        </span>
      </span>
    </template>

    <!-- <template #side-menu-item-2>
      <span class='el:m-label'>
        <icon name='email' class='el:m-label__icon el:amx-Mr(0.75em)'></icon>
        <span class='el:m-label__text el:amx-Fs(0.875em)'>
          {{ $t('user.side_menus.account_settings.email') }}
        </span>
      </span>
    </template> -->

    <template #side-menu-item-2>
      <span class="el:m-label">
        <icon name="password" class="el:m-label__icon el:amx-Mr(0.75em)"></icon>
        <span class="el:m-label__text el:amx-Fs(0.875em)">
          {{ $t("user.side_menus.account_settings.password") }}
        </span>
      </span>
    </template>

    <template #side-menu-item-1-content>
      <profile></profile>
    </template>

    <template #side-menu-item-2-content>
      <edit-password class="el:amx-Mt(1.5em)@<sm"></edit-password>
    </template>
  </side-menu>
</template>

<script>
import SideMenu from "./SideMenu.vue";
import Profile from "./account_settings/Profile.vue";
import EditPassword from "./account_settings/EditPassword.vue";

export default {
  components: {
    SideMenu,
    Profile,
    EditPassword
  }
};
</script>
