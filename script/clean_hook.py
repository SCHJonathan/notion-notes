import os
import sys
from urllib.parse import quote


def inplace_replace(filename, old_string):
    # Safely read the input filename using 'with'
    with open(filename) as f:
        s = f.read()
        if old_string not in s:
            print(f'"{old_string}" not found in {filename}')
            return

    # Safely write the changed content, if found in the file
    with open(filename, 'w') as f:
        print(f'Changing "{old_string}" to "image" in {filename}')
        s = s.replace(old_string, 'image')
        f.write(s)


if __name__ == '__main__':
    note_folder = f'../notes/{sys.argv[1]}'
    for root, dirs, files in os.walk(note_folder):
        image_dir = dirs[0]

        # refactor the reference of image folder in markdown file
        markdown_file_path = f'{os.path.abspath(root)}/{files[0]}'
        new_markdown_file_path = f'{os.path.abspath(root)}/{os.path.basename(root)}.md'
        encoded_image_dir = quote(image_dir)
        inplace_replace(markdown_file_path, encoded_image_dir)
        os.rename(markdown_file_path, new_markdown_file_path)

        # # rename image folder
        notion_suffix = image_dir.split(' ')[-1]
        image_dir_path = os.path.abspath(f'{root}/{image_dir}')
        new_image_dir_path = f'{os.path.abspath(root)}/image'
        os.rename(image_dir_path, new_image_dir_path)

        break
