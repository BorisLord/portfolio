import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const projects = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/projects/" }),
  schema: z.object({
    title: z.string(),
    link: z.string().optional(),
    git: z.string().optional(),
    stack: z.string(),
    sortOrder: z.number(),
  }),
});

const intro = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/intro/" }),
});

export const collections = {
  projects,
  intro,
};
