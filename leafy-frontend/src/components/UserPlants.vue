<template>
  <div class="user-plants">
    <v-select
      :items="userPlantList"
      item-title="plantNicknameWithPlantName"
      item-value="userPlantId"
      label="식물 선택"
      v-model="userPlantId"
      variant="outlined"
      color="#2F6B4F"
      density="comfortable"
      @input="onSelectChange"
    ></v-select>
  </div>
</template>

<script>
import { ref, watch, onMounted } from 'vue';
import api from '@/api/api';

export default {
  name: 'UserPlants',
  props: {
    userId: {
      type: Number,
      required: true,
    },
  },
  setup(props, { emit }) {
    const userPlantList = ref([]);
    const userPlantId = ref(null);

    const fetchUserPlants = async () => {
      try {
        const response = await api.get(`/api/v1/user-plants/user/${props.userId}`);
        userPlantList.value = response.data.
        filter(plant => plant.plant !== null).
        map(plant => ({
          ...plant,
          plantNicknameWithPlantName: `${plant.plantNickname} (${plant.plant.plantName})`,
        }));
      } catch (error) {
        console.error(error);
      }
    };

    const onSelectChange = (value) =>{
      emit('updated-userplant-id', value);
    }

    onMounted(fetchUserPlants);

    watch(
      () => userPlantId.value,
      (newUserPlantId, oldUserPlantId) => {
        if (newUserPlantId !== oldUserPlantId) {
          onSelectChange(userPlantId.value);
        }
      }
    );


    return { userPlantList, userPlantId, onSelectChange };
  },

};
</script>

<style scoped>
.user-plants {
  margin-bottom: 4px;
}
</style>
