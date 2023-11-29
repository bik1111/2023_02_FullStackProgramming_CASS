import puppeteer from "puppeteer-extra";
import { insertCafeInfo } from "../service/crawl.js";

export const crawlstarBucksInfo = async (req, res) => {
    try {
        const browser = await puppeteer.launch({
            headless: false,
            executablePath: '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
        });

        const page = await browser.newPage();
        await page.setViewport({ width: 1280, height: 800 });

        await page.goto('https://www.starbucks.co.kr/store/store_map.do?disp=locale');

        // Wait for the Seoul button to be clickable
        await page.waitForSelector('#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step1 > div.loca_step1_cont > ul > li:nth-child(1) > a');
        await page.click('#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step1 > div.loca_step1_cont > ul > li:nth-child(1) > a');

        // Wait for the first district to be clickable
        await page.waitForSelector('#mCSB_2_container > ul > li:nth-child(1) > a');
        await page.click('#mCSB_2_container > ul > li:nth-child(1) > a');

        // Wait for the container to load
        await page.waitForSelector('#mCSB_3_container');


        // Get the HTML content
        const html = await page.content();

        // Log the HTML content to check if the data is present
        console.log(html);

        // Extract information using Cheerio
        const Info = await page.evaluate(() => {
            return $('#mCSB_3_container > ul > li').map((_, el) => {
                const name = $(el).data('name');
                const lat = $(el).data('lat');
                const lng = $(el).data('long');
                const address = $(el).find('.result_details').text().trim();
                const number = address.match(/\d{4}-\d{4}/)[0];
                return { name, address, number, lat, lng };
            }).get();
        });

        // Log the number of elements and their HTML to check
        console.log(Info.length);
        console.log(Info);

        // Insert the information into the database
        for (const cafe of Info) {
            await insertCafeInfo(cafe.name, cafe.lat, cafe.lng, cafe.address, cafe.number);
        }

        await browser.close();
    } catch (err) {
        console.error('Error during scraping:', err);
    }
};
