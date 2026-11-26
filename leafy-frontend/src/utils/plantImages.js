import { reactive } from 'vue';
import api from '@/api/api';

// Plant image URLs. The my-plants and diary APIs do not include image URLs, so they are looked up from the full plant list.
const imageByPlantId = reactive({});
let loaded = false;

export function loadPlantImages() {
  if (loaded) return;
  loaded = true;
  api.get('/api/v1/plants')
    .then(response => {
      response.data.forEach(plant => {
        imageByPlantId[plant.plantId] = plant.imageUrl;
      });
    })
    .catch(error => {
      loaded = false;
      console.error(error);
    });
}

export function plantImage(plant) {
  if (!plant) return '';
  return plant.imageUrl || imageByPlantId[plant.plantId] || '';
}
