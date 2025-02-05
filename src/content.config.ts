import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const projects = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/" }),
  schema: z.object({
    title: z.string(),
    link: z.string().optional(),
    git: z.string().optional(),
    stack: z.string(),
    // description: z.string(),
  }),
});

export const collections = {
  projects,
};
