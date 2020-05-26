<template>
  <side-menu :num-of-items="2">
    <template #side-menu-item-1="{ selected }">
      <span class="el:m-label">
        <icon
          name="profile"
          :color="selected === 1 ? 'fg' : 'fgM'"
          class="el:m-label__icon el:amx-Mr(0.75em)"
        ></icon>
        <span
          class="el:m-label__text el:amx-Fs(0.875em)"
          :class="selected === 1 ? 'el:amx-C_fg' : 'el:amx-C_fgM'"
        >
          {{ $t("user.side_menus.account_settings.profile") }}
        </span>
      </span>
    </template>

    <template #side-menu-item-2="{ selected }">
      <span class="el:m-label">
        <icon
          name="password"
          :color="selected === 2 ? 'fg' : 'fgM'"
          class="el:m-label__icon el:amx-Mr(0.75em)"
        ></icon>
        <span
          class="el:m-label__text el:amx-Fs(0.875em)"
          :class="selected === 2 ? 'el:amx-C_fg' : 'el:amx-C_fgM'"
        >
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
import SideMenu from "~components/SideMenu.vue";
import Profile from "~components/account_settings/Profile.vue";
import EditPassword from "~components/account_settings/EditPassword.vue";

export default {
  components: {
    SideMenu,
    Profile,
    EditPassword
  }
};
</script>
