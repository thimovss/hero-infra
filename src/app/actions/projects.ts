'use server';

import {
    CreateBucketCommand,
    GetObjectCommand,
    ListBucketsCommand,
    PutObjectCommand,
    S3Client
} from "@aws-sdk/client-s3";
import { Readable } from 'stream';

const s3Client = new S3Client({
    region: "eu-west-2"
});

const HERO_INFRA_PROJECT_NAME_PREFIX = "hero-infra-project-";
const HERO_INFRA_PROJECT_METADATA_FILE = "project.json";

export type Project = {
    id: string,
    name: string,
}

export async function listProjects(): Promise<Project[]> {
    try {
        const data = await s3Client.send(new ListBucketsCommand({}));
        const buckets = data.Buckets || [];
        const projectBuckets = buckets.filter(bucket => bucket.Name!.startsWith(HERO_INFRA_PROJECT_NAME_PREFIX));
        // return the metadata for each project
        return Promise.all(projectBuckets.map(async bucket => {
            const metaDataFile = await s3Client.send(new GetObjectCommand({
                Bucket: bucket.Name!,
                Key: HERO_INFRA_PROJECT_METADATA_FILE,
            }));
            // @ts-ignore
            const metaDataFileContent = (await Readable.from(metaDataFile.Body!).toArray()).toString();
            return JSON.parse(metaDataFileContent);
        }));
    } catch (err) {
        console.log("Error", err);
        return [];
    }
}

export async function createProject(name: string, id: string) {
    // id can only contain letters, numbers, and hyphens
    if (!/^[a-zA-Z0-9-]+$/.test(id)) {
        throw new Error("Invalid project ID, must only contain letters, numbers, and hyphens");
    }

    const BUCKET_ID = HERO_INFRA_PROJECT_NAME_PREFIX + id;

    try {
        await s3Client.send(new CreateBucketCommand({
            Bucket: BUCKET_ID
        }));
        const metadata = {
            name,
            id,
            resources: [],
        }
        await s3Client.send(new PutObjectCommand({
            Bucket: BUCKET_ID,
            Key: HERO_INFRA_PROJECT_METADATA_FILE,
            Body: JSON.stringify(metadata, null, 4),
        }));
    } catch (err) {
        console.log("Error", err);
    }
}
