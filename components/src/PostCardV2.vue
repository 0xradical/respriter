<template>
  <div class="post-card">
    <div class="post-card__cover">
      <img :src="post.coverImage" />
    </div>
    <div class="post-card__publishing-date">
      {{ post.publishedAt }}
    </div>
    <div class="post-card__title">
      {{ post.title }}
    </div>
    <div class="post-card__subtitle">
      {{ post.subtitle }}
    </div>
  </div>
</template>

<script>
  export default {
    props: {
      post: {
        title: {
          type: String,
          required: true
        },
        slug: {
          type: String,
          required: false
        },
        publishedAt: {
          type: String,
          required: false
        },
        coverImage: {
          type: String,
          required: false
        },
        subtitle: {
          type: String,
          required: false
        }
      }
    }
  };
</script>

<style lang="scss" scoped>
  .post-card {
    &__cover {
      img {
        width: 100%;
        height: 150px;
        object-fit: cover;
      }
    }

    &__publishing-date {
      margin-top: 1.6rem;
      font-size: 1rem;
      line-height: 1;
      color: var(--foreground-medium);
    }

    &__title {
      margin-top: 0.8rem;
      font-weight: bold;
      font-size: 1.6rem;
      line-height: 1.2;
      color: var(--foreground);
    }

    &__subtitle {
      margin-top: 0.8rem;
      font-size: 1.2rem;
      line-height: 1.5;
      color: var(--foreground);
    }
  }
</style>
